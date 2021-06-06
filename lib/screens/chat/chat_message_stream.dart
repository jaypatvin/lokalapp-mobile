import 'package:cloud_firestore/cloud_firestore.dart';

class MessageStreamFirebase {
  static Stream getUserChats(String userId) =>
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
