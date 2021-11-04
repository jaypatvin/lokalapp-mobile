import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/conversation.dart';
import '../../../utils/functions.utils.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class ReplyMessageWidget extends StatelessWidget {
  final bool isRepliedByUser;
  final Color color;
  final Conversation message;
  final VoidCallback? onCancelReply;

  const ReplyMessageWidget({
    required this.message,
    this.isRepliedByUser = true,
    this.onCancelReply,
    this.color = const Color(0xFFF1FAFF),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.media != null && message.media!.isNotEmpty)
          SizedBox(
            height: 90.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: message.media!.length,
              itemBuilder: (ctx, index) {
                return NetworkPhotoThumbnail(
                  galleryItem: message.media![index],
                  fit: BoxFit.cover,
                  onTap: () => openGallery(context, index, message.media!),
                );
              },
            ),
          ),
        if (message.message != null)
          Text(
            message.message!,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: isRepliedByUser
                      ? Colors.black.withOpacity(0.7)
                      : Color(0xFFF1FAFF).withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
          ),
      ],
    );
  }
}
