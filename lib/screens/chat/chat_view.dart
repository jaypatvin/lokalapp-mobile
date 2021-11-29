import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/conversation.dart';
import '../../providers/auth.dart';
import '../../services/api/api.dart';
import '../../services/api/chat_api_service.dart';
import '../../services/api/conversation_api_service.dart';
import '../../services/database.dart';
import '../../services/local_image_service.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import 'chat_bubble.dart';
import 'chat_profile.dart';
import 'components/chat_input.dart';
import 'components/message_stream.dart';

class ChatView extends StatefulWidget {
  static const routeName = '/chat/view';
  final ChatModel? chat;

  // There may be better ways to implement this
  final bool createMessage;
  final List<String>? members; // should include shopId or productId
  final String? shopId;
  final String? productId;

  const ChatView(
    this.createMessage, {
    this.chat,
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
  final FocusNode _chatInputNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  String replyId = "";
  Conversation? replyMessage;
  bool showImagePicker = false;
  late final CustomPickerDataProvider provider;
  Color? _indicatorColor;

  Conversation? _currentlySendingMessage;
  bool _sendingMessage = false;
  bool _userSentLastMessage = false;

  // this is placed outside of the build function to
  // avoid rebuilds on the StreamBuilder
  Stream<QuerySnapshot<Map<String, dynamic>>>? _messageStream;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _messageSubscription;

  // needed to keep track if creating a new message
  bool _createNewMessage = false;
  String? _chatTitle = "New message";
  ChatModel? _chat;

  List<QueryDocumentSnapshot<Map<String, dynamic>>>? _conversations;

  late final ChatAPIService _chatApiService;
  late final ConversationAPIService _conversationAPIService;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _chatApiService = ChatAPIService(context.read<API>());
    _conversationAPIService = ConversationAPIService(context.read<API>());

    // we're reusing the image picker used in the post and comments section
    provider = context.read<CustomPickerDataProvider>();
    provider.onPickMax.addListener(showMaxAssetsText);
    // no need to add onPickListener (like in post_details) since we are not
    // using SingleChildScrollView to build the screen
    provider.pickedNotifier.addListener(() => setState(() {}));

    providerInit();
    final userId = context.read<Auth>().user!.id;
    if (!widget.createMessage) {
      _loading = false;
      this._chatTitle = widget.chat!.title;
      this._chat = widget.chat;
      _messageStream = Database.instance.getConversations(this._chat!.id);
      this._messageSubscription =
          this._messageStream!.listen(_messageStreamListener);

      _indicatorColor =
          widget.chat!.members.contains(userId) ? kTealColor : kPurpleColor;
    } else {
      _indicatorColor =
          widget.members!.contains(userId) ? kTealColor : kPurpleColor;
      checkExistingChat();
    }
    _createNewMessage = widget.createMessage;
  }

  @override
  void dispose() {
    // we need to clear and remove the picked images and listeners
    // so that we can use it in its initial state on other screens
    provider.picked.clear();
    provider.removeListener(showMaxAssetsText);
    this._messageSubscription?.cancel();

    super.dispose();
  }

  void _messageStreamListener(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.docs.isEmpty) return;
    final conversation = Conversation.fromDocument(snapshot.docs.first);
    final user = context.read<Auth>().user!;
    this._conversations = snapshot.docs;
    debugPrint("$conversation");
    if (this.mounted) {
      if (conversation.senderId == user.id) {
        setState(() {
          this._sendingMessage = false;
          this._currentlySendingMessage = null;
          this._userSentLastMessage = true;
        });
      } else {
        setState(() {
          this._userSentLastMessage = false;
        });
      }
    }
  }

  Future<void> providerInit() async {
    final pathList = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    provider.resetPathList(pathList);
  }

  Future<void> checkExistingChat() async {
    try {
      if (widget.members == null) return;

      this._chat = await _chatApiService.getChatByMembers(
        members: widget.members!,
      );
      this._chatTitle = this._chat!.title;
      this._messageStream = Database.instance.getConversations(this._chat!.id);
      _createNewMessage = false;
      this._messageSubscription =
          this._messageStream?.listen(_messageStreamListener);

      setState(() {
        this._loading = false;
      });
    } catch (e) {
      // do nothing as it means there are no chat by these members
      print(e.toString());
      setState(() {
        this._loading = false;
      });
    }
  }

  void showMaxAssetsText() {
    // TODO: maybe use OKToast plugin
    final snackBar = SnackBar(
      content: Text("You have reached the limit of 5 media per message."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<List<Map<String, dynamic>>> _getMedia(
    List<AssetEntity> assets,
  ) async {
    final _imageService = LocalImageService.instance;
    final media = <Map<String, dynamic>>[];

    for (int index = 0; index < assets.length; index++) {
      final asset = assets[index];
      final file = await asset.file;
      final url = await _imageService!.uploadImage(
        file: file!,
        name: 'post_photo',
      );
      media.add({
        "url": url,
        "type": "image",
        "order": index,
      });
    }
    return media;
  }

  void _onSendMessage() async {
    try {
      final user = context.read<Auth>().user!;
      setState(() {
        this._sendingMessage = true;
        this._currentlySendingMessage = Conversation(
          archived: false,
          createdAt: DateTime.now(),
          message: chatInputController.text,
          senderId: user.id!,
          sentAt: DateTime.now(),
          media: [],
        );
      });
      if (this._createNewMessage) {
        final media = await _getMedia(provider.picked);
        final chat = await _chatApiService.createChat(
          body: {
            'user_id': user.id,
            'reply_to': replyId,
            'message': chatInputController.text,
            'media': media,
            'members': [...widget.members!],
            'shop_id': widget.shopId,
            'product_id': widget.productId,
          },
        );

        setState(() {
          this._chat = chat;
          this._chatTitle = chat.title;
          this._createNewMessage = false;
          this._messageStream = Database.instance.getConversations(chat.id);
        });
        this._messageSubscription =
            this._messageStream!.listen(_messageStreamListener);
      } else {
        final media = _getMedia(provider.picked);
        _conversationAPIService.createConversation(
          chatId: this._chat!.id,
          body: {
            'user_id': user.id,
            'reply_to': replyId,
            'message': chatInputController.text,
            'media': media,
          },
        );
      }
      chatInputController.clear();
      setState(() {
        provider.picked.clear();
        replyId = "";
        showImagePicker = false;
        this.replyMessage = null;
        this.replyId = "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  void _onDeleteMessage(String id) async {
    late SnackBar snackBar;
    try {
      await _conversationAPIService.deleteConversation(
        chatId: this._chat!.id,
        messageId: id,
      );
      snackBar = SnackBar(content: Text("Message deleted succesfully."));
    } catch (e) {
      snackBar = SnackBar(content: Text(e.toString()));
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _buildMessages() {
    if (_messageStream == null && _sendingMessage) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        reverse: true,
        itemCount: 1,
        itemBuilder: (ctx, index) {
          return ChatBubble(conversation: this._currentlySendingMessage);
        },
      );
    }
    if (_messageStream == null) {
      return Center(
        child: Text(
          "Say Hi...",
          style: TextStyle(fontSize: 24.0.sp, color: Colors.black),
        ),
      );
    }
    return MessageStream(
      messageStream: this._messageStream,
      onReply: (id, conversation) {
        this.replyId = id;
        setState(() {
          replyMessage = conversation;
        });
      },
      onDelete: (id) => _onDeleteMessage(id),
      trailing: _buildAdditionalStates(),
    );
  }

  Widget _buildChatInput() {
    return Container(
      color: kInviteScreenColor,
      padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
      child: ChatInput(
        onMessageSend: _onSendMessage,
        onShowImagePicker: () => setState(() {
          this.showImagePicker = !this.showImagePicker;
        }),
        onCancelReply: () => setState(() => replyMessage = null),
        onImageRemove: (index) => setState(() {
          provider.picked.removeAt(index);
        }),
        chatInputController: this.chatInputController,
        replyMessage: this.replyMessage,
        images: this.provider.picked,
        onTextFieldTap: () => setState(() => showImagePicker = false),
        chatFocusNode: _chatInputNode,
      ),
    );
  }

  Widget _buildImagePicker() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: this.showImagePicker ? 150.0.h : 0.0.h,
      child: ImageGalleryPicker(
        provider,
        pickerHeight: 150.h,
        assetHeight: 150.h,
        assetWidth: 150.h,
        thumbSize: 200,
        enableSpecialItemBuilder: true,
      ),
    );
  }

  Widget _buildDetailsButton() {
    return IconButton(
      icon: Icon(
        Icons.more_horiz,
        color: Colors.white,
        size: 30.r,
      ),
      onPressed: () {
        if (this._chat != null)
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (ctx) => ChatProfile(
                this._chat,
                this._conversations,
              ),
            ),
          );
      },
    );
  }

  Widget _buildAdditionalStates() {
    Widget child = SizedBox();
    if (this._sendingMessage) {
      child = ChatBubble(conversation: this._currentlySendingMessage);
    } else if (_userSentLastMessage) {
      child = SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5),
          child: Text(
            "Delivered",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: _indicatorColor ?? kYellowColor,
        titleText: this._chatTitle,
        titleStyle: TextStyle(color: Colors.white, fontSize: 16.0),
        leadingColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
        actions: [_buildDetailsButton()],
      ),
      body: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardBarColor: Colors.transparent,
          actions: [
            KeyboardActionsItem(
              focusNode: _chatInputNode,
              displayActionBar: false,
              toolbarButtons: [
                (node) {
                  return TextButton(
                    onPressed: () => node.unfocus(),
                    child: Text(
                      "Done",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  );
                },
              ],
            ),
          ],
        ),
        disableScroll: true,
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: _loading
            ? SizedBox.expand(
                child: Lottie.asset(kAnimationLoading),
              )
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: _buildMessages(),
                    ),
                  ),
                  _buildChatInput(),
                  _buildImagePicker(),
                ],
              ),
      ),
    );
  }
}
