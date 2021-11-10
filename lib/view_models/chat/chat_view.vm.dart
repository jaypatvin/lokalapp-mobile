import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../../utils/constants/themes.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

class ChatViewViewModel extends ChangeNotifier {
  ChatViewViewModel(
    this.context,
    this.createMessage, {
    this.chat,
    this.members,
    this.shopId,
    this.productId,
  });

  final BuildContext context;
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
  late final CustomPickerDataProvider provider;

  String _chatTitle = "New message";
  String get chatTitle => _chatTitle;

  bool _sendingMessage = false;
  bool get sendingMessage => _sendingMessage;

  Conversation? _currentlySendingMessage;
  Conversation? get currentlySendingMessage => _currentlySendingMessage;

  bool _userSentLastMessage = false;
  bool get userSentLastMessage => _userSentLastMessage;

  String _replyId = "";

  Conversation? _replyMessage;
  Conversation? get replyMessage => _replyMessage;

  bool _showImagePicker = false;
  bool get showImagePicker => _showImagePicker;

  Stream<QuerySnapshot>? messageStream;
  StreamSubscription? _messageSubscription;

  // needed to keep track if creating a new message
  bool _createNewMessage = false;
  ChatModel? _chat;

  List<QueryDocumentSnapshot>? _conversations;

  bool _loading = false;
  bool get isLoading => _loading;

  void init() {
    _chatApiService = ChatAPIService(context.read<API>());
    _conversationAPIService = ConversationAPIService(context.read<API>());

    // we're reusing the image picker used in the post and comments section
    provider = Provider.of<CustomPickerDataProvider>(context, listen: false);
    provider.onPickMax.addListener(_showMaxAssetsText);
    // no need to add onPickListener (like in post_details) since we are not
    // using SingleChildScrollView to build the screen
    provider.pickedNotifier.addListener(() => notifyListeners());

    _providerInit();
    final userId = context.read<Auth>().user!.id;
    if (!this.createMessage) {
      this._chatTitle = this.chat!.title;
      this._chat = this.chat;
      messageStream = _db.getConversations(this._chat!.id);
      this._messageSubscription =
          this.messageStream!.listen(_messageStreamListener);

      indicatorColor =
          this.chat!.members.contains(userId) ? kTealColor : kPurpleColor;
    } else {
      indicatorColor =
          this.members!.contains(userId) ? kTealColor : kPurpleColor;
      _checkExistingChat();
    }
    _createNewMessage = this.createMessage;
  }

  @override
  void dispose() {
    print('called dispose');
    // we need to clear and remove the picked images and listeners
    // so that we can use it in its initial state on other screens
    provider.picked.clear();
    provider.removeListener(_showMaxAssetsText);
    this._messageSubscription?.cancel();

    super.dispose();
  }

  void _messageStreamListener(QuerySnapshot snapshot) {
    final conversation = Conversation.fromDocument(snapshot.docs.first);
    final user = context.read<Auth>().user!;
    this._conversations = snapshot.docs;
    if (conversation.senderId == user.id) {
      this._sendingMessage = false;
      this._currentlySendingMessage = null;
      this._userSentLastMessage = true;
    } else {
      this._userSentLastMessage = false;
    }
    notifyListeners();
  }

  Future<void> _providerInit() async {
    final pathList = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    provider.resetPathList(pathList);
  }

  Future<void> _checkExistingChat() async {
    try {
      if (members == null) return;
      this._loading = true;
      notifyListeners();

      this._chat = await _chatApiService.getChatByMembers(
        members: this.members!,
      );
      this._chatTitle = this._chat!.title;
      this.messageStream = _db.getConversations(this._chat!.id);
      _createNewMessage = false;
      this._messageSubscription =
          this.messageStream?.listen(_messageStreamListener);

      this._loading = false;
      notifyListeners();
    } catch (e) {
      // do nothing as it means there are no chat by these members
      print(e.toString());
      this._loading = false;
      notifyListeners();
    }
  }

  void _showMaxAssetsText() {
    // TODO: maybe use OKToast plugin
    final snackBar = SnackBar(
      content: Text("You have reached the limit of 5 media per message."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onSendMessage() async {
    final message = chatInputController.text;
    final picked = provider.picked;
    final showImagePicker = _showImagePicker;
    final replyMessage = _replyMessage;
    final replyId = _replyId;
    try {
      final user = context.read<Auth>().user!;
      this._sendingMessage = true;
      this._currentlySendingMessage = Conversation(
        archived: false,
        createdAt: DateTime.now(),
        message: chatInputController.text,
        senderId: user.id!,
        sentAt: DateTime.now(),
        media: [],
      );
      notifyListeners();

      if (this._createNewMessage) {
        final media = await _getMedia(provider.picked);
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

        this._chat = chat;
        this._chatTitle = chat.title;
        this._createNewMessage = false;
        this.messageStream = _db.getConversations(chat.id);
        this._messageSubscription = this.messageStream!.listen(
              _messageStreamListener,
            );
        notifyListeners();
      } else {
        final media = _getMedia(provider.picked);
        _conversationAPIService.createConversation(
          chatId: this._chat!.id,
          body: {
            'user_id': user.id,
            'reply_to': _replyId,
            'message': chatInputController.text,
            'media': media,
          },
        );
      }
      this.chatInputController.clear();
      this.provider.picked.clear();
      this._showImagePicker = false;
      this._replyMessage = null;
      this._replyId = "";
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      this.chatInputController.text = message;
      this.provider.picked = picked;
      this._showImagePicker = showImagePicker;
      this._replyMessage = replyMessage;
      this._replyId = replyId;
      this._sendingMessage = false;
      this._currentlySendingMessage = null;
      notifyListeners();
    }
  }

  void onDeleteMessage(String id) async {
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

  void onGoToChatDetails() {
    if (chat == null) return;
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (ctx) => ChatProfile(
          this._chat,
          this._conversations,
        ),
      ),
    );
  }

  void onShowImagePicker() {
    _showImagePicker = !_showImagePicker;
    notifyListeners();
  }

  void onReply(String id, Conversation conversation) {
    this._replyId = id;
    this._replyMessage = conversation;
    notifyListeners();
  }

  void onCancelReply() {
    _replyMessage = null;
    notifyListeners();
  }

  void onImageRemove(int index) {
    provider.picked.removeAt(index);
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
        "url": url,
        "type": "image",
        "order": index,
      });
    }
    return media;
  }
}
