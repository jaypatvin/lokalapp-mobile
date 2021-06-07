import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/chat.dart';
import 'package:lokalapp/models/conversation.dart';
import 'package:lokalapp/utils/themes.dart';

// class ChatBubble extends StatelessWidget {
//   ChatBubble({this.text, this.sender, this.isMe, this.time});
//   final String sender;
//   final String text;
//   final bool isMe;
//   final String time;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//         children: <Widget>[
//           // Text(this.time),
//           Text(
//             this.sender,
//             style: TextStyle(
//                 fontSize: 12.0, color: Colors.black, fontFamily: "Goldplay"),
//           ),
//           Material(
//             borderRadius:
//                 isMe ? BorderRadius.circular(8) : BorderRadius.circular(8),
//             elevation: 5.0,
//             color: isMe ? kTealColor : Color(0xffF1FAFF),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: Text(
//                 '$text',
//                 style: TextStyle(
//                   color: isMe ? Colors.white : Colors.black,
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class MessagesWidget extends StatelessWidget {
  final Conversation message;
  final bool isMe;

  const MessagesWidget({
    @required this.message,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          // CircleAvatar(
          //     radius: 16, backgroundImage: NetworkImage()),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 140),
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[100] : Theme.of(context).accentColor,
              borderRadius: isMe
                  ? borderRadius
                      .subtract(BorderRadius.only(bottomRight: radius))
                  : borderRadius
                      .subtract(BorderRadius.only(bottomLeft: radius)),
            ),
            child: buildMessage(),
          ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );
}
