import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../models/conversation.dart';
import '../../models/lokal_images.dart';
import '../../providers/user.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/photo_view_gallery/gallery/gallery_network_photo_view.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import 'components/reply_message.dart';

class ChatBubble extends StatelessWidget {
  final Conversation? conversation;
  final DocumentReference? replyMessage;
  const ChatBubble({
    required this.conversation,
    this.replyMessage,
  });

  void openGallery(
    BuildContext context,
    final int index,
    final List<LokalImages> galleryItems,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryNetworkPhotoView(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  // TODO: fix this for all types of media
  Widget buildMessageImages(BuildContext context, List<LokalImages> images) {
    var count = images.length;
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: count,
      crossAxisCount: 2,
      itemBuilder: (ctx, index) {
        return NetworkPhotoThumbnail(
          galleryItem: images[index],
          onTap: () => openGallery(context, index, images),
        );
      },
      staggeredTileBuilder: (index) {
        if (count % 2 != 0 && index == 0) {
          return new StaggeredTile.count(2, 1);
        }
        return new StaggeredTile.count(1, 1);
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget buildReplyMessage(bool isUser) {
    // TODO: change design according to FIGMA
    return FutureBuilder<DocumentSnapshot>(
      future: this.replyMessage!.get(),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) return Text("Error, cannot retrieve message");
        if (snapshot.hasData && snapshot.data!.data() != null) {
          final conversation = Conversation.fromDocument(snapshot.data!);
          return ReplyMessageWidget(
            message: conversation,
            isRepliedByUser: isUser,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildBubble(BuildContext context, bool isUser) {
    //dynamically add widgets to be returned
    final widgets = <Widget>[];
    final space = SizedBox(height: 6.0.h);

    if (replyMessage != null) {
      widgets.add(buildReplyMessage(isUser));
      widgets.add(space);
    }

    if (conversation!.media != null && conversation!.media!.length > 0) {
      widgets.add(buildMessageImages(context, conversation!.media!));
      widgets.add(space);
    }

    if (conversation!.message != null && conversation!.message!.isNotEmpty) {
      widgets.add(
        Text(
          conversation!.message!,
          style: TextStyle(
            color: isUser ? Colors.black : Colors.white,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cUser = context.read<CurrentUser>();
    final isUser = conversation!.senderId == cUser.id;

    final radius = Radius.circular(12.0.r);
    final borderRadius = BorderRadius.all(radius);
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0.r),
          margin: EdgeInsets.all(10.0.r),
          constraints: BoxConstraints(maxWidth: width * 3 / 4),
          decoration: BoxDecoration(
            color: isUser ? Color(0xFFF1FAFF) : kTealColor,
            borderRadius: borderRadius,
          ),
          child: buildBubble(context, isUser),
        ),
      ],
    );
  }
}
