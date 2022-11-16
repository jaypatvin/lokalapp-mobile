import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/chat_model.dart';
import '../../../models/conversation.dart';
import '../collection_impl.dart';

class ChatsCollection extends CollectionImpl {
  ChatsCollection(super.collection);

  Stream<List<ChatModel>> getUserChats(String userId) {
    return reference
        .where('members', arrayContains: userId)
        .orderBy('last_message.created_at', descending: true)
        .snapshots()
        .map(
          (e) => e.docs
              .map<ChatModel?>(_toChatModel)
              .whereType<ChatModel>()
              .toList(),
        );
  }

  Stream<List<Conversation>> getConversations(String? chatId) {
    return reference
        .doc(chatId)
        .collection('conversation')
        // .orderBy('archived')
        // .where('archived', isNotEqualTo: true)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(_convertToConversation);
  }

  Stream<List<Conversation>> getConversationsWithMedia(String chatId) {
    return reference
        .doc(chatId)
        .collection('conversation')
        .where('media', isNotEqualTo: [])
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(_convertToConversation);
  }

  Future<Conversation?> getConversation(
    String chatId,
    String conversationId,
  ) async {
    try {
      final doc = await reference
          .doc(chatId)
          .collection('conversation')
          .doc(conversationId)
          .get();

      return Conversation.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }

  Future<Conversation?> getConversationByReference(
    DocumentReference<Map<String, dynamic>> reference,
  ) async {
    try {
      final doc = await reference.get();
      return Conversation.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }

  Future<ChatModel?> getChat(String chatId) async {
    try {
      final doc = await reference.doc(chatId).get();
      return ChatModel.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }

  ChatModel? _toChatModel(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return ChatModel.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }

  List<Conversation> _convertToConversation(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs
        .map<Conversation?>((doc) {
          try {
            return Conversation.fromDocument(doc);
          } catch (e, stack) {
            FirebaseCrashlytics.instance.recordError(e, stack);
            return null;
          }
        })
        .whereType<Conversation>()
        .toList();
  }
}
