import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/chat_model.dart';
import '../../models/conversation.dart';
import '../../models/failure_exception.dart';
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

  const ChatView({
    required this.createMessage,
    this.chat,
    this.members,
    this.shopId,
    this.productId,
  });

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  // TODO: clean up repeated codes
  // these repeated codes are from post_details.dart

  final TextEditingController chatInputController = TextEditingController();
  final FocusNode _chatInputNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  String replyId = '';
  Conversation? replyMessage;
  bool showImagePicker = false;
  late final CustomPickerDataProvider imageProvider;
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

  List<AssetEntity> _sendImages = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _chatApiService = ChatAPIService(context.read<API>());
    _conversationAPIService = ConversationAPIService(context.read<API>());

    // we're reusing the image picker used in the post and comments section
    imageProvider = context.read<CustomPickerDataProvider>();
    imageProvider.onPickMax.addListener(showMaxAssetsText);
    // no need to add onPickListener (like in post_details) since we are not
    // using SingleChildScrollView to build the screen
    imageProvider.pickedNotifier.addListener(() => setState(() {}));

    // providerInit();
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

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    // we need to clear and remove the picked images and listeners
    // so that we can use it in its initial state on other screens
    imageProvider.picked.clear();
    imageProvider.removeListener(showMaxAssetsText);
    _messageSubscription?.cancel();

    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (showImagePicker) {
          final result = await PhotoManager.requestPermissionExtend();
          if (result.isAuth) {
            final pathList = await PhotoManager.getAssetPathList(
              onlyAll: true,
              type: RequestType.image,
            );
            imageProvider.resetPathList(pathList);
          }
          setState(() {});
        }
        break;
      default:
        break;
    }
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

  Future<void> onShowImagePicker() async {
    if (!showImagePicker) {
      final result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        final pathList = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );
        imageProvider.resetPathList(pathList);
      }
    }

    setState(() {
      showImagePicker = !showImagePicker;
    });
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
    final _imageService = context.read<LocalImageService>();
    final media = <Map<String, dynamic>>[];

    for (int index = 0; index < assets.length; index++) {
      final asset = assets[index];
      final file = await asset.file;
      final url = await _imageService.uploadImage(
        file: file!,
        src: kChatImagesSrc,
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
    final _replyId = replyId;
    final _message = chatInputController.text;
    final _replyMessage = replyMessage;

    try {
      setState(() {
        _sendImages = [...imageProvider.picked];
        chatInputController.clear();
        replyId = '';
        showImagePicker = false;
        replyMessage = null;
        imageProvider.picked.clear();
      });

      final user = context.read<Auth>().user!;
      setState(() {
        _sendingMessage = true;
        _currentlySendingMessage = Conversation(
          archived: false,
          createdAt: DateTime.now(),
          message: _message,
          senderId: user.id!,
          sentAt: DateTime.now(),
          media: [],
        );
      });

      if (_createNewMessage) {
        final media = await _getMedia(_sendImages);
        final chat = await _chatApiService.createChat(
          body: {
            'user_id': user.id,
            'reply_to': _replyId,
            'message': _message,
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
        final media = await _getMedia(_sendImages);
        _conversationAPIService.createConversation(
          chatId: _chat!.id,
          body: {
            'user_id': user.id,
            'reply_to': _replyId,
            'message': _message,
            'media': media,
          },
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Error sending message, try again.');
      setState(() {
        chatInputController.text = _message;
        replyId = _replyId;
        replyMessage = _replyMessage;
        imageProvider.picked.addAll(_sendImages);
        _sendingMessage = false;
        _currentlySendingMessage = null;
      });
    }
  }

  Future<void> _onDeleteMessage(String id) async {
    try {
      await _conversationAPIService.deleteConversation(
        chatId: _chat!.id,
        messageId: id,
      );
      showToast('Message deleted succesfully.');
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
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
        onShowImagePicker: onShowImagePicker,
        onCancelReply: () => setState(() => replyMessage = null),
        onImageRemove: (index) =>
            setState(() => imageProvider.picked.removeAt(index)),
        chatInputController: chatInputController,
        replyMessage: replyMessage,
        images: imageProvider.picked,
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
        imageProvider,
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
            AppNavigator.appPageRoute(
              builder: (_) => ChatProfile(_chat, _conversations),
            ),
          );
        }
      },
    );
  }

  Widget _buildAdditionalStates() {
    Widget child = const SizedBox();
    if (_sendingMessage) {
      child = ChatBubble(
        conversation: _currentlySendingMessage,
        images: _sendImages,
      );
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
