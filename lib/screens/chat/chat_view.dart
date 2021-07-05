import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/conversation.dart';
import '../../providers/user.dart';
import '../../services/database.dart';
import '../../services/local_image_service.dart';
import '../../services/lokal_api_service.dart';
import '../../utils/functions.utils.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import '../../widgets/photo_view_gallery/thumbnails/asset_photo_thumbnail.dart';
import 'chat_profile.dart';
import 'components/message_stream.dart';
import 'components/reply_message.dart';

class ChatView extends StatefulWidget {
  final QueryDocumentSnapshot chatDocument;

  // There may be better ways to implement this
  final bool createMessage;
  final List<String> members;
  final String shopId;
  final String productId;

  const ChatView(
    this.createMessage, {
    this.chatDocument,
    this.members,
    this.shopId,
    this.productId,
  });

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  // TODO: clean up repeated codes
  // these repeated codes are from post_details.dart

  final TextEditingController chatInputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String replyId = "";
  Conversation replyMessage;
  bool showImagePicker = false;
  CustomPickerDataProvider provider;

  // this is placed outside of the build function to
  // avoid rebuilds on the StreamBuilder
  Stream<QuerySnapshot> _messageStream;

  // needed to keep track if creating a new message
  bool _createNewMessage = false;
  String _chatId = "";

  @override
  void initState() {
    super.initState();

    // we're reusing the image picker used in the post and comments section
    provider = Provider.of<CustomPickerDataProvider>(context, listen: false);
    provider.onPickMax.addListener(showMaxAssetsText);
    // no need to add onPickListener (like in post_details) since we are not
    // using SingleChildScrollView to build the screen
    provider.pickedNotifier.addListener(() => setState(() {}));

    providerInit();

    if (!widget.createMessage) {
      this._chatId = widget.chatDocument.id;
      _messageStream = Database.instance.getConversations(this._chatId);
    }
    _createNewMessage = widget.createMessage;
  }

  @override
  void dispose() {
    // we need to clear and remove the picked images and listeners
    // so that we can use it in its initial state on other screens
    provider.picked.clear();
    provider.removeListener(showMaxAssetsText);

    super.dispose();
  }

  Future<void> providerInit() async {
    final pathList = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    provider.resetPathList(pathList);
  }

  void showMaxAssetsText() {
    // TODO: maybe use OKToast plugin
    final snackBar = SnackBar(
      content: Text("You have reached the limit of 5 media per post."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> onSendMessage() async {
    final user = Provider.of<CurrentUser>(context, listen: false);
    var service = Provider.of<LocalImageService>(context, listen: false);
    var gallery = <Map<String, dynamic>>[];

    for (var asset in provider.picked) {
      var file = await asset.file;
      var url = await service.uploadImage(file: file, name: 'post_photo');
      gallery.add({
        "url": url,
        "type": "image",
        "order": provider.pickIndex(asset),
      });
    }

    // TODO: clean this up, we're still creating a body directly
    final Map<String, dynamic> body = {
      "user_id": user.id,
      "reply_to": replyId,
      "message": chatInputController.text,
      "media": gallery,
    };

    if (this._createNewMessage) {
      body.addAll({
        "members": widget.members,
        "shop_id": widget.shopId,
        "product_id": widget.productId,
      });
      LokalApiService.instance.chat
          .create(
        data: body,
        idToken: user.idToken,
      )
          .then((response) {
        if (response.statusCode != 200) {
          return;
        }

        final Map<String, dynamic> body = jsonDecode(response.body);
        final String id = body["data"]["id"];
        setState(() {
          this._chatId = body["data"]["id"];
          this._createNewMessage = false;
          this._messageStream = Database.instance.getConversations(id);
        });
      });
    } else {
      await LokalApiService.instance.chat.createConversation(
        chatId: this._chatId,
        data: body,
        idToken: user.idToken,
      );
    }
    chatInputController.clear();
    setState(() {
      provider.picked.clear();
      replyId = "";
      showImagePicker = false;
    });
  }

  // TODO: create component to be used here and in comments
  Widget buildChatTextField(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: chatInputController,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        hintText: "Type a message",
        hintStyle: kTextStyle.copyWith(
          fontWeight: FontWeight.normal,
          color: Colors.grey[400],
        ),
        alignLabelWithHint: true,
        suffixIcon: Padding(
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: kTealColor,
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => onSendMessage(),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // TODO: create component to be used here and in comments
  Widget buildChatInputImages(BuildContext context) {
    if (provider.picked.length <= 0) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      addRepaintBoundaries: true,
      itemCount: provider.picked.length,
      itemBuilder: (ctx, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 0.5),
          height: 100,
          width: 100,
          child: AssetPhotoThumbnail(
            galleryItem: provider.picked[index],
            onTap: () => openInputGallery(
              context,
              index,
              provider.picked,
            ),
            onRemove: () => setState(() => provider.picked.removeAt(index)),
            fit: BoxFit.cover,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildChatInput({BuildContext context}) {
    return Column(
      children: [
        replyMessage != null
            ? ReplyMessageWidget(
                message: replyMessage,
                onCancelReply: () => setState(() => replyMessage = null))
            : Container(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: kTealColor),
                ),
                child: Icon(
                  MdiIcons.fileImageOutline,
                  color: kTealColor,
                ),
              ),
              onTap: () {
                setState(() {
                  this.showImagePicker = !this.showImagePicker;
                });
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  border: Border.all(color: kTealColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        height: provider.picked.length > 0 ? 100 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: buildChatInputImages(context),
                      ),
                      buildChatTextField(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        backgroundColor: kYellowColor,
        titleText: widget.chatDocument.data()["title"],
        titleStyle: kTextStyle.copyWith(color: kNavyColor),
        leadingColor: kNavyColor,
        onPressedLeading: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: kNavyColor,
              size: 33,
            ),
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (ctx) {
                  return ChatProfile(chatDocument: widget.chatDocument);
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: _messageStream == null
                    ? Center(
                        child: Text(
                          "Say Hi...",
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      )
                    : MessageStream(
                        messageStream: this._messageStream,
                        onRightSwipe: (id, conversation) {
                          this.replyId = id;
                          setState(() {
                            replyMessage = conversation;
                          });
                        },
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: buildChatInput(context: context),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: this.showImagePicker ? 200.0 : 0.0,
              child: ImageGalleryPicker(
                provider,
                pickerHeight: 200,
                assetHeight: 200,
                assetWidth: 200,
                thumbSize: 200,
                enableSpecialItemBuilder: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
