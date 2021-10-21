import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/conversation.dart';
import '../../../utils/constants/themes.dart';

class ReplyMessageWidget extends StatelessWidget {
  final bool isRepliedByUser;
  final Conversation? message;
  final VoidCallback? onCancelReply;

  const ReplyMessageWidget({
    required this.message,
    this.isRepliedByUser = true,
    this.onCancelReply,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            color: isRepliedByUser ? kTealColor : Color(0xFFF1FAFF),
            width: 2.0.w,
          ),
          SizedBox(width: 6.0.w),
          Expanded(child: buildReplyMessage()),
        ],
      ),
    );
  }

  Widget buildReplyMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Replying to",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: isRepliedByUser ? kTealColor : Color(0xFFF1FAFF),
                  ),
                ),
              ),
              if (onCancelReply != null)
                GestureDetector(
                  child: Icon(Icons.close, size: 16.0.r),
                  onTap: onCancelReply,
                )
            ],
          ),
          SizedBox(height: 5.0.h),
          if(message!.message != null)
          Text(
            message!.message!,
            style: TextStyle(
              color: isRepliedByUser ? Colors.black : Color(0xFFF1FAFF),
            ),
          ),
        ],
      ),
    );
  }
}
