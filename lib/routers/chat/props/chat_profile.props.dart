import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/chat_model.dart';

class ChatProfileProps {
  const ChatProfileProps(this.chat, this.conversations);
  final ChatModel? chat;
  final List<QueryDocumentSnapshot>? conversations;
}
