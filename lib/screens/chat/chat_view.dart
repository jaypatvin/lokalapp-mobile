import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
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

  // TODO: use factory method for createMessage
  const ChatView(
    // ignore: avoid_positional_boolean_parameters
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

  String replyId = '';
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
  String? _chatTitle = 'New message';
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
      _chatTitle = widget.chat!.title;
      _chat = widget.chat;
      _messageStream = Database.instance.getConversations(_chat!.id);
      _messageSubscription = _messageStream!.listen(_messageStreamListener);

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
    _messageSubscription?.cancel();

    super.dispose();
  }

  void _messageStreamListener(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.docs.isEmpty) return;
    final conversation = Conversation.fromDocument(snapshot.docs.first);
    final user = context.read<Auth>().user!;
    _conversations = snapshot.docs;
    if (mounted) {
      if (conversation.senderId == user.id) {
        setState(() {
          _sendingMessage = false;
          _currentlySendingMessage = null;
          _userSentLastMessage = true;
        });
      } else {
        setState(() {
          _userSentLastMessage = false;
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

      _chat = await _chatApiService.getChatByMembers(
        members: widget.members!,
      );
      _chatTitle = _chat!.title;
      _messageStream = Database.instance.getConversations(_chat!.id);
      _createNewMessage = false;
      _messageSubscription = _messageStream?.listen(_messageStreamListener);

      setState(() {
        _loading = false;
      });
    } catch (e) {
      // do nothing as it means there are no chat by these members
      debugPrint(e.toString());
      setState(() {
        _loading = false;
      });
    }
  }

  void showMaxAssetsText() {
    showToast('You have reached the limit of 5 media per message.');
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
        'url': url,
        'type': 'image',
        'order': index,
      });
    }
    return media;
  }

  Future<void> _onSendMessage() async {
    try {
      final user = context.read<Auth>().user!;
      setState(() {
        _sendingMessage = true;
        _currentlySendingMessage = Conversation(
          archived: false,
          createdAt: DateTime.now(),
          message: chatInputController.text,
          senderId: user.id!,
          sentAt: DateTime.now(),
          media: [],
        );
      });
      if (_createNewMessage) {
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
          _chat = chat;
          _chatTitle = chat.title;
          _createNewMessage = false;
          _messageStream = Database.instance.getConversations(chat.id);
        });
        _messageSubscription = _messageStream!.listen(_messageStreamListener);
      } else {
        final media = _getMedia(provider.picked);
        _conversationAPIService.createConversation(
          chatId: _chat!.id,
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
        replyId = '';
        showImagePicker = false;
        replyMessage = null;
        replyId = '';
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> _onDeleteMessage(String id) async {
    try {
      await _conversationAPIService.deleteConversation(
        chatId: _chat!.id,
        messageId: id,
      );
      showToast('Message delete succesfully.');
    } catch (e) {
      showToast(e.toString());
    }
  }

  Widget _buildMessages() {
    if (_messageStream == null && _sendingMessage) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        itemCount: 1,
        itemBuilder: (ctx, index) {
          return ChatBubble(conversation: _currentlySendingMessage);
        },
      );
    }
    if (_messageStream == null) {
      return Center(
        child: Text(
          'Say Hi...',
          style: TextStyle(fontSize: 24.0.sp, color: Colors.black),
        ),
      );
    }
    return MessageStream(
      messageStream: _messageStream,
      onReply: (id, conversation) {
        replyId = id;
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
          showImagePicker = !showImagePicker;
        }),
        onCancelReply: () => setState(() => replyMessage = null),
        onImageRemove: (index) => setState(() {
          provider.picked.removeAt(index);
        }),
        chatInputController: chatInputController,
        replyMessage: replyMessage,
        images: provider.picked,
        onTextFieldTap: () => setState(() => showImagePicker = false),
        chatFocusNode: _chatInputNode,
      ),
    );
  }

  Widget _buildImagePicker() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: showImagePicker ? 150.0.h : 0.0.h,
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
        if (_chat != null) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (ctx) => ChatProfile(
                _chat,
                _conversations,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAdditionalStates() {
    Widget child = const SizedBox();
    if (_sendingMessage) {
      child = ChatBubble(conversation: _currentlySendingMessage);
    } else if (_userSentLastMessage) {
      child = const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(right: 10, bottom: 5),
          child: Text(
            'Delivered',
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
        titleText: _chatTitle,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
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
                      'Done',
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
                      decoration: const BoxDecoration(
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
