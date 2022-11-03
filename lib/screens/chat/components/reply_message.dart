import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/conversation.dart';
import '../../../utils/functions.utils.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class ReplyMessageWidget extends StatelessWidget {
  const ReplyMessageWidget({
    Key? key,
    required this.message,
    this.isRepliedByUser = true,
    this.onCancelReply,
    this.color = const Color(0xFFF1FAFF),
    this.uuid = const Uuid(),
  }) : super(key: key);

  final bool isRepliedByUser;
  final Color color;
  final Conversation message;
  final VoidCallback? onCancelReply;
  final Uuid uuid;

  @override
  Widget build(BuildContext context) {
    if (message.archived) {
      return Text(
        'Deleted Message',
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.media != null && message.media!.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.builder(
              // Media only contains 5 images/media
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: message.media!.length,
              itemBuilder: (ctx, index) {
                final uri = Uri.parse(message.media![index].url);
                return NetworkPhotoThumbnail(
                  heroTag: '${uri.pathSegments.last}_${uuid.v4()}',
                  galleryItem: message.media![index],
                  onTap: () => openGallery(context, index, message.media),
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
                      : const Color(0xFFF1FAFF).withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
          ),
      ],
    );
  }
}
