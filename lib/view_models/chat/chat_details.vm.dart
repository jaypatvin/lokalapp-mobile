import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/conversation.dart';
import '../../models/failure_exception.dart';
import '../../models/lokal_user.dart';
import '../../models/post_requests/chat/chat_create.request.dart';
import '../../models/post_requests/chat/conversation.request.dart';
import '../../providers/auth.dart';
import '../../services/api/api.dart';
import '../../services/api/chat_api_service.dart';
import '../../services/api/conversation_api_service.dart';
import '../../services/database/collections/chats.collection.dart';
import '../../services/database/database.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
import '../../utils/constants/assets.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

class ChatDetailsViewModel extends ViewModel {
  ChatDetailsViewModel({
    required this.members,
    this.shopId,
    this.productId,
    ChatModel? chat,
  })  : assert(members.isNotEmpty),
        _chat = chat;

  final List<String> members;
  final String? shopId;
  final String? productId;

  late final ChatAPIService _chatAPIService;
  late final ConversationAPIService _conversationAPIService;
  late final CustomPickerDataProvider imageProvider;
  late final ChatsCollection _db;
  late final LokalUser _currentUser;

  Stream<List<Conversation>>? _messageStream;
  Stream<List<Conversation>>? get messageStream => _messageStream;
  StreamSubscription<List<Conversation>>? _messageSubscription;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _showImagePicker = false;
  bool get showImagePicker => _showImagePicker;
  set showImagePicker(bool value) {
    _showImagePicker = value;
    notifyListeners();
  }

  ChatModel? _chat;
  ChatModel? get chat => _chat;

  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;

  bool _isSendingMessage = false;
  bool get isSendingMessage => _isSendingMessage;

  Conversation? _currentSendingMessage;
  Conversation? get currentSendingMessage => _currentSendingMessage;

  bool _didUserSendLastMessage = false;
  bool get didUserSendLastMessage => _didUserSendLastMessage;

  // For sending messages
  String _message = '';
  String get message => _message;
  set message(String value) {
    _message = value;
    notifyListeners();
  }

  String _replyId = '';
  Conversation? _replyTo;
  Conversation? get replyTo => _replyTo;
  set replyTo(Conversation? value) {
    _replyTo = value;
    notifyListeners();
  }

  List<AssetEntity> _sendingImages = [];
  List<AssetEntity> get sendingImages => _sendingImages;

  Conversation? _sendingReplyTo;
  Conversation? get sendingReplyTo => _sendingReplyTo;

  @override
  void init() {
    final api = context.read<API>();
    _chatAPIService = ChatAPIService(api);
    _conversationAPIService = ConversationAPIService(api);
    imageProvider = context.read<CustomPickerDataProvider>();
    _db = context.read<Database>().chats;
    _currentUser = context.read<Auth>().user!;

    imageProvider.onPickMax.addListener(_showMaxAssetsText);
    imageProvider.pickedNotifier.addListener(notifyListeners);

    _chatInit();
  }

  @override
  void dispose() {
    imageProvider.picked.clear();
    imageProvider.onPickMax.removeListener(_showMaxAssetsText);
    imageProvider.removeListener(notifyListeners);
    _messageSubscription?.cancel();
    super.dispose();
  }

  Future<void> _chatInit() async {
    try {
      _chat ??= await _chatAPIService.getChatByMembers(members: members);

      if (_chat != null) {
        _messageStream = _db.getConversations(_chat!.id);
        _messageSubscription = _messageStream?.listen(_messageStreamListener);
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  void _showMaxAssetsText() =>
      showToast('You have reached the limit of 5 media per message.');

  Future<List<ConversationMedia>> _getMedia(
    List<AssetEntity> assets,
  ) async {
    final imageService = context.read<LocalImageService>();
    final media = <ConversationMedia>[];

    for (int index = 0; index < assets.length; index++) {
      final asset = assets[index];
      final file = await asset.file;
      final url = await imageService.uploadImage(
        file: file!,
        src: kChatImagesSrc,
      );
      media.add(
        ConversationMedia(
          url: url,
          order: index,
          type: MediaType.image,
        ),
      );
    }
    return media;
  }

  void _messageStreamListener(List<Conversation> conversations) {
    if (conversations.isEmpty) return;
    final conversation = conversations.first;
    final user = context.read<Auth>().user!;
    _conversations = conversations;
    if (conversation.senderId == user.id) {
      _isSendingMessage = false;
      _currentSendingMessage = null;
      _didUserSendLastMessage = !conversation.archived;
    } else {
      _didUserSendLastMessage = false;
    }
    if (hasListeners) notifyListeners();
  }

  void onReply(String id, Conversation replyTo) {
    if (replyTo.archived) return;

    _replyId = id;
    _replyTo = replyTo;

    notifyListeners();
  }

  Future<bool> onWillPop() async {
    if (_showImagePicker) {
      _showImagePicker = false;
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<void> onSendMessage() async {
    showImagePicker = false;
    final replyId = _replyId;
    final message = _message;
    final replyTo = _replyTo;
    _sendingImages = [...imageProvider.picked];
    _sendingReplyTo = _replyTo;

    void onError(Object e, [StackTrace? stack]) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Error sending message, try again.');
      _message = message;
      _replyId = replyId;
      _replyTo = replyTo;
      imageProvider.picked.addAll(_sendingImages);
      _currentSendingMessage = null;
      _isSendingMessage = false;
      notifyListeners();
    }

    try {
      imageProvider.picked.clear();
      _message = '';
      _replyId = '';
      _replyTo = null;

      _isSendingMessage = true;
      _currentSendingMessage = Conversation(
        id: '_sending_mesage',
        archived: false,
        createdAt: DateTime.now(),
        message: message,
        senderId: _currentUser.id,
        sentAt: DateTime.now(),
        media: [],
      );
      notifyListeners();

      final media = await _getMedia(_sendingImages);
      if (_chat != null) {
        _createConversation(
          ConversationRequest(
            userId: _currentUser.id,
            replyTo: replyId,
            media: media,
            message: message,
          ),
          onError,
        );
      } else {
        _chat = await _chatAPIService.createChat(
          request: ChatCreateRequest(
            userId: _currentUser.id,
            members: members,
            shopId: shopId,
            productId: productId,
            message: message,
            media: media,
          ),
        );
        _messageStream = _db.getConversations(_chat!.id);
        _messageSubscription = _messageStream?.listen(_messageStreamListener);
      }
      notifyListeners();
    } catch (e, stack) {
      onError(e, stack);
    }
  }

  Future<void> _createConversation(
    ConversationRequest request, [
    void Function(Object, [StackTrace])? onError,
  ]) async {
    try {
      await _conversationAPIService.createConversation(
        chatId: _chat!.id,
        request: request,
      );
    } catch (e, stack) {
      onError?.call(e, stack);
    }
  }

  Future<void> onDeleteMessage(String id) async {
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

  Future<void> onShowImagePicker() async {
    if (!showImagePicker) {
      final result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        final pathList = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );
        imageProvider.resetPathList(pathList);
      } else {
        if (Platform.isIOS) {
          showToast('Please allow Lokal access to Photos.');
        } else {
          showToast('Please allow Lokal access to your Gallery.');
        }
      }
    }

    _showImagePicker = !_showImagePicker;
    notifyListeners();
  }

  void onImageRemove(int index) {
    imageProvider.picked.removeAt(index);
    notifyListeners();
  }
}
