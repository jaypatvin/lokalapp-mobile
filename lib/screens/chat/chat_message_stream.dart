import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lokalapp/models/chat.dart';
import 'package:lokalapp/models/lokal_user.dart';
import 'package:lokalapp/utils/chat_utils.dart';

class MessageStreamFirebase {
  static Stream getUsers(List members, String userId) =>
      FirebaseFirestore.instance
          .collection('chats')
          .where("members", arrayContainsAny: [userId])
          // .orderBy('created_at', descending: true)
          .snapshots();

  static Stream getConversation(String chatId) => FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('conversation')
      .orderBy('created_at', descending: true)
      // .limit(_lt)
      .snapshots();
}
