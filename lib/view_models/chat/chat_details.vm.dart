import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/conversation.dart';
import '../../models/failure_exception.dart';
import '../../models/lokal_user.dart';
import '../../providers/auth.dart';
import '../../services/api/api.dart';
import '../../services/api/chat_api_service.dart';
import '../../services/api/conversation_api_service.dart';
import '../../services/database.dart';
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
  late final Database _db;
  late final LokalUser _currentUser;

  Stream<QuerySnapshot<Map<String, dynamic>>>? _messageStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get messageStream =>
      _messageStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messageSubscription;

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

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _conversations = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get conversations =>
      _conversations;

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

  @override
  void init() {
    final _api = context.read<API>();
    _chatAPIService = ChatAPIService(_api);
    _conversationAPIService = ConversationAPIService(_api);
    imageProvider = context.read<CustomPickerDataProvider>();
    _db = Database.instance;
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

  void _messageStreamListener(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.docs.isEmpty) return;
    final conversation = Conversation.fromDocument(snapshot.docs.first);
    final user = context.read<Auth>().user!;
    _conversations = conversations;
    if (conversation.senderId == user.id) {
      _isSendingMessage = false;
      _currentSendingMessage = null;
      _didUserSendLastMessage = true;
    } else {
      _didUserSendLastMessage = false;
    }
    if (hasListeners) notifyListeners();
  }

  void onReply(String id, Conversation replyTo) {
    _replyId = id;
    _replyTo = replyTo;
    notifyListeners();
  }

  Future<void> onSendMessage() async {
    showImagePicker = false;
    final _replyId = this._replyId;
    final _message = this._message;
    final _replyTo = this._replyTo;
    _sendingImages = [...imageProvider.picked];

    try {
      imageProvider.picked.clear();
      this._message = '';
      this._replyId = '';
      this._replyTo = null;

      _isSendingMessage = true;
      _currentSendingMessage = Conversation(
        archived: false,
        createdAt: DateTime.now(),
        message: _message,
        senderId: _currentUser.id!,
        sentAt: DateTime.now(),
        media: [],
      );
      notifyListeners();

      final _media = await _getMedia(_sendingImages);
      if (_chat != null) {
        _conversationAPIService.createConversation(
          chatId: _chat!.id,
          body: {
            'user_id': _currentUser.id,
            'reply_to': _replyId,
            'message': _message,
            'media': _media,
          },
        );
      } else {
        _chat = await _chatAPIService.createChat(
          body: {
            'user_id': _currentUser.id,
            'reply_to': _replyId,
            'message': _message,
            'media': _media,
            'members': members,
            'shop_id': shopId,
            'product_id': productId,
          },
        );
        _messageStream = _db.getConversations(_chat!.id);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Error sending message, try again.');
      this._message = _message;
      this._replyId = _replyId;
      this._replyTo = _replyTo;
      imageProvider.picked.addAll(_sendingImages);
    } finally {
      _isSendingMessage = false;
      _currentSendingMessage = null;
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