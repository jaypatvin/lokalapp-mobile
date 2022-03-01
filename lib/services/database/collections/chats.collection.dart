import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/chat_model.dart';
import '../../../models/conversation.dart';
import '../collection_impl.dart';
import '../database.dart';

class ChatsCollection extends CollectionImpl {
  ChatsCollection(Collection collection) : super(collection);

  Stream<List<ChatModel>> getUserChats(String userId) {
    return reference
        .where('members', arrayContains: userId)
        .orderBy('last_message.created_at', descending: true)
        .snapshots()
        .map(
          (e) => e.docs.map((doc) => ChatModel.fromDocument(doc)).toList(),
        );
  }

  Stream<List<Conversation>> getConversations(String? chatId) {
    return reference
        .doc(chatId)
        .collection('conversation')
        .orderBy('archived')
        .where('archived', isNotEqualTo: true)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (e) => e.docs.map((doc) => Conversation.fromDocument(doc)).toList(),
        );
  }

  Stream<List<Conversation>> getConversationsWithMedia(String chatId) {
    return reference
        .doc(chatId)
        .collection('conversation')
        .where('media', isNotEqualTo: [])
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (e) => e.docs.map((doc) => Conversation.fromDocument(doc)).toList(),
        );
  }

  Future<Conversation> getConversation(
    String chatId,
    String conversationId,
  ) async {
    final _doc = await reference
        .doc(chatId)
        .collection('conversation')
        .doc(conversationId)
        .get();

    return Conversation.fromDocument(_doc);
  }

  Future<Conversation> getConversationByReference(
    DocumentReference<Map<String, dynamic>> reference,
  ) async {
    final _doc = await reference.get();
    return Conversation.fromDocument(_doc);
  }

  Future<ChatModel> getChat(String chatId) async {
    final _doc = await reference.doc(chatId).get();
    return ChatModel.fromDocument(_doc);
  }
}
