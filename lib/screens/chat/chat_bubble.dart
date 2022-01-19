import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../models/conversation.dart';
import '../../models/lokal_images.dart';
import '../../providers/auth.dart';
import '../../utils/constants/themes.dart';
import '../../utils/functions.utils.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import 'components/reply_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.conversation,
    Key? key,
    this.replyMessage,
    this.forFocus = false,
  }) : super(key: key);

  final Conversation? conversation;
  final DocumentReference? replyMessage;
  final bool forFocus;

  Widget _buildChatBubble({
    required BuildContext context,
    required bool isUser,
    Conversation? replyMessage,
  }) {
    final radius = Radius.circular(12.0.r);
    final borderRadius = BorderRadius.all(radius);

    final messageWidgets = <Widget>[];
    final space = SizedBox(height: 6.0.h);
    final bool isUserReplyMessage = replyMessage != null &&
        replyMessage.senderId == context.read<Auth>().user!.id;

    if (conversation!.media != null && conversation!.media!.isNotEmpty) {
      messageWidgets.add(
        _MessageImages(
          images: conversation!.media!,
          forFocus: forFocus,
        ),
      );
      messageWidgets.add(space);
    }

    if (conversation!.message != null && conversation!.message!.isNotEmpty) {
      messageWidgets.add(
        Text(
          conversation!.message!,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: isUser ? Colors.black : Colors.white,
              ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(left: 10.0, bottom: 10.0.r, right: 10.0.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyMessage != null)
            Transform.translate(
              offset: Offset(0, 8.0.h),
              child: Container(
                margin: EdgeInsets.only(left: 5.0.w),
                padding: EdgeInsets.all(10.0.r),
                decoration: BoxDecoration(
                  color: isUserReplyMessage
                      ? const Color(0xFFF1FAFF).withOpacity(0.7)
                      : kTealColor.withOpacity(0.7),
                  borderRadius: borderRadius,
                ),
                child: ReplyMessageWidget(
                  message: replyMessage,
                  isRepliedByUser: isUserReplyMessage,
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(10.0.r),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFFF1FAFF) : kTealColor,
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messageWidgets,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cUser = context.read<Auth>().user!;
    final isUser = conversation!.senderId == cUser.id;
    final width = MediaQuery.of(context).size.width;

    if (replyMessage != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: replyMessage!.get(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error, cannot retrieve message');
          }
          if (snapshot.hasData && snapshot.data!.data() != null) {
            final conversation = Conversation.fromDocument(snapshot.data!);
            return Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: width * 3 / 4),
                  child: _buildChatBubble(
                    context: context,
                    isUser: isUser,
                    replyMessage: conversation,
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: width * 3 / 4),
          child: _buildChatBubble(
            context: context,
            isUser: isUser,
          ),
        ),
      ],
    );
  }
}

class _MessageImages extends StatelessWidget {
  const _MessageImages({
    Key? key,
    required this.images,
    this.fit = BoxFit.cover,
    this.forFocus = false,
  }) : super(key: key);

  final List<LokalImages> images;
  final BoxFit fit;
  final bool forFocus;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0.w,
      crossAxisSpacing: 4.0.h,
      children: images.map<StaggeredGridTile>((image) {
        final index = images.indexOf(image);
        final crossAxisCellCount = images.length % 2 != 0 && index == 0 ? 2 : 1;
        return StaggeredGridTile.count(
          crossAxisCellCount: crossAxisCellCount,
          mainAxisCellCount: 1,
          child: NetworkPhotoThumbnail(
            key: Key('chat_message_${images[index].url}'),
            heroTag: forFocus ? '_focused_${images[index].url}' : null,
            galleryItem: images[index],
            onTap: () => openGallery(context, index, images),
          ),
        );
      }).toList(),
    );
  }
}
