import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/conversation.dart';
import '../../providers/auth.dart';
import '../../screens/chat/chat_profile.dart';
import '../../services/api/api.dart';
import '../../services/api/chat_api_service.dart';
import '../../services/api/conversation_api_service.dart';
import '../../services/database.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

class ChatViewViewModel extends ViewModel {
  ChatViewViewModel({
    required this.createMessage,
    this.chat,
    this.members,
    this.shopId,
    this.productId,
  });

  final bool createMessage;

  final ChatModel? chat;
  final List<String>? members; // should include shopId or productId
  final String? shopId;
  final String? productId;

  final _db = Database.instance;
  late final ChatAPIService _chatApiService;
  late final ConversationAPIService _conversationAPIService;

  // --
  final TextEditingController chatInputController = TextEditingController();
  final FocusNode chatInputNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  late final Color indicatorColor;
  late final CustomPickerDataProvider imageProvider;

  String _chatTitle = 'New message';
  String get chatTitle => _chatTitle;

  bool _sendingMessage = false;
  bool get sendingMessage => _sendingMessage;

  Conversation? _currentlySendingMessage;
  Conversation? get currentlySendingMessage => _currentlySendingMessage;

  bool _userSentLastMessage = false;
  bool get userSentLastMessage => _userSentLastMessage;

  String _replyId = '';

  Conversation? _replyMessage;
  Conversation? get replyMessage => _replyMessage;

  bool _showImagePicker = false;
  bool get showImagePicker => _showImagePicker;
  set showImagePicker(bool value) {
    _showImagePicker = value;
    notifyListeners();
  }

  Stream<QuerySnapshot>? messageStream;
  StreamSubscription? _messageSubscription;

  // needed to keep track if creating a new message
  bool _createNewMessage = false;
  ChatModel? _chat;

  List<QueryDocumentSnapshot>? _conversations;

  bool _loading = false;
  bool get isLoading => _loading;

  @override
  void init() {
    _chatApiService = ChatAPIService(context.read<API>());
    _conversationAPIService = ConversationAPIService(context.read<API>());

    // we're reusing the image picker used in the post and comments section
    imageProvider =
        Provider.of<CustomPickerDataProvider>(context, listen: false);
    imageProvider.onPickMax.addListener(_showMaxAssetsText);
    // no need to add onPickListener (like in post_details) since we are not
    // using SingleChildScrollView to build the screen
    imageProvider.pickedNotifier.addListener(() => notifyListeners());

    final userId = context.read<Auth>().user!.id;
    if (!createMessage) {
      _chatTitle = chat!.title;
      _chat = chat;
      messageStream = _db.getConversations(_chat!.id);
      _messageSubscription = messageStream!.listen(_messageStreamListener);

      indicatorColor =
          chat!.members.contains(userId) ? kTealColor : kPurpleColor;
    } else {
      indicatorColor = members!.contains(userId) ? kTealColor : kPurpleColor;
      _checkExistingChat();
    }
    _createNewMessage = createMessage;
  }

  @override
  void dispose() {
    debugPrint('called dispose');
    // we need to clear and remove the picked images and listeners
    // so that we can use it in its initial state on other screens
    imageProvider.picked.clear();
    imageProvider.removeListener(_showMaxAssetsText);
    _messageSubscription?.cancel();

    super.dispose();
  }

  @override
  Future<void> onResume() async {
    if (_showImagePicker) {
      final result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        final pathList = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );
        imageProvider.resetPathList(pathList);
      }
    }
  }

  void _messageStreamListener(QuerySnapshot snapshot) {
    final conversation = Conversation.fromDocument(snapshot.docs.first);
    final user = context.read<Auth>().user!;
    _conversations = snapshot.docs;
    if (conversation.senderId == user.id) {
      _sendingMessage = false;
      _currentlySendingMessage = null;
      _userSentLastMessage = true;
    } else {
      _userSentLastMessage = false;
    }
    notifyListeners();
  }

  Future<void> _checkExistingChat() async {
    try {
      if (members == null) return;
      _loading = true;
      notifyListeners();

      _chat = await _chatApiService.getChatByMembers(
        members: members!,
      );
      _chatTitle = _chat!.title;
      messageStream = _db.getConversations(_chat!.id);
      _createNewMessage = false;
      _messageSubscription = messageStream?.listen(_messageStreamListener);

      _loading = false;
      notifyListeners();
    } catch (e) {
      // do nothing as it means there are no chat by these members
      debugPrint(e.toString());
      _loading = false;
      notifyListeners();
    }
  }

  void _showMaxAssetsText() {
    showToast('You have reached the limit of 5 media per message.');
  }

  Future<void> onSendMessage() async {
    final message = chatInputController.text;
    final picked = imageProvider.picked;
    final showImagePicker = _showImagePicker;
    final replyMessage = _replyMessage;
    final replyId = _replyId;
    try {
      final user = context.read<Auth>().user!;
      _sendingMessage = true;
      _currentlySendingMessage = Conversation(
        archived: false,
        createdAt: DateTime.now(),
        message: chatInputController.text,
        senderId: user.id!,
        sentAt: DateTime.now(),
        media: [],
      );
      notifyListeners();

      if (_createNewMessage) {
        final media = await _getMedia(imageProvider.picked);
        final chat = await _chatApiService.createChat(
          body: {
            'user_id': user.id,
            'reply_to': _replyId,
            'message': chatInputController.text,
            'media': media,
            'members': members,
            'shop_id': shopId,
            'product_id': productId,
          },
        );

        _chat = chat;
        _chatTitle = chat.title;
        _createNewMessage = false;
        messageStream = _db.getConversations(chat.id);
        _messageSubscription = messageStream!.listen(
          _messageStreamListener,
        );
        notifyListeners();
      } else {
        final media = _getMedia(imageProvider.picked);
        _conversationAPIService.createConversation(
          chatId: _chat!.id,
          body: {
            'user_id': user.id,
            'reply_to': _replyId,
            'message': chatInputController.text,
            'media': media,
          },
        );
      }
      chatInputController.clear();
      imageProvider.picked.clear();
      _showImagePicker = false;
      _replyMessage = null;
      _replyId = '';
      notifyListeners();
    } catch (e) {
      showToast(e.toString());
      chatInputController.text = message;
      imageProvider.picked = picked;
      _showImagePicker = showImagePicker;
      _replyMessage = replyMessage;
      _replyId = replyId;
      _sendingMessage = false;
      _currentlySendingMessage = null;
      notifyListeners();
    }
  }

  Future<void> onDeleteMessage(String id) async {
    try {
      await _conversationAPIService.deleteConversation(
        chatId: _chat!.id,
        messageId: id,
      );
      showToast('Message deleted succesfully.');
    } catch (e) {
      showToast(e.toString());
    }
  }

  void onGoToChatDetails() {
    if (chat == null) return;
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

  Future<void> onShowImagePicker() async {
    if (!_showImagePicker) {
      final result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        final pathList = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );
        imageProvider.resetPathList(pathList);
      }
    }

    _showImagePicker = !_showImagePicker;
    notifyListeners();
  }

  void onReply(String id, Conversation conversation) {
    _replyId = id;
    _replyMessage = conversation;
    notifyListeners();
  }

  void onCancelReply() {
    _replyMessage = null;
    notifyListeners();
  }

  void onImageRemove(int index) {
    imageProvider.picked.removeAt(index);
    notifyListeners();
  }

  void onTextFieldTap() {
    _showImagePicker = false;
    notifyListeners();
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
}
