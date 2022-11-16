import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/conversation.dart';
import '../../models/lokal_images.dart';
import '../../providers/auth.dart';
import '../../utils/constants/themes.dart';
import '../../utils/functions.utils.dart' as utils;
import '../../widgets/photo_view_gallery/thumbnails/file_photo_thumbnail.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import 'components/reply_message.dart';

class ChatBubble extends HookWidget {
  const ChatBubble({
    required this.conversation,
    super.key,
    this.replyMessage,
    this.forFocus = false,
    this.images = const [],
  });

  final Conversation? conversation;
  final Conversation? replyMessage;
  final bool forFocus;
  final List<AssetEntity> images;

  Container _buildChatBubble({
    required BuildContext context,
    required bool isUser,
    Conversation? replyMessage,
  }) {
    const radius = Radius.circular(8);
    const borderRadius = BorderRadius.all(radius);

    final messageWidgets = <Widget>[];
    const space = SizedBox(height: 12);
    final bool isUserReplyMessage = replyMessage != null &&
        replyMessage.senderId == context.read<Auth>().user!.id;

    if (conversation!.media != null && conversation!.media!.isNotEmpty) {
      messageWidgets.add(
        _MessageImages(
          key: UniqueKey(),
          images: conversation!.media!,
          forFocus: forFocus,
        ),
      );
    }

    if (images.isNotEmpty) {
      messageWidgets.add(
        _FileImages(
          key: UniqueKey(),
          images: images,
          forFocus: forFocus,
        ),
      );
    }

    if (conversation!.message != null && conversation!.message!.isNotEmpty) {
      messageWidgets.add(
        Text(
          conversation!.message!,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: conversation!.archived
                    ? Colors.grey
                    : isUser
                        ? Colors.black
                        : Colors.white,
                fontStyle: conversation!.archived ? FontStyle.italic : null,
              ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyMessage != null)
            Transform.translate(
              offset: const Offset(0, 8.0),
              child: Container(
                margin: const EdgeInsets.only(left: 5.0),
                padding: const EdgeInsets.all(10.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFFF1FAFF) : kTealColor,
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: utils
                  .intersperse<Widget>(
                    space,
                    messageWidgets,
                  )
                  .toList(), //messageWidgets,
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

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: width * 3 / 4),
          child: _buildChatBubble(
            context: context,
            isUser: isUser,
            replyMessage: replyMessage,
          ),
        ),
      ],
    );
  }
}

class _MessageImages extends StatelessWidget {
  const _MessageImages({
    super.key,
    required this.images,
    this.forFocus = false,
  });

  final List<ILokalImage> images;
  final bool forFocus;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
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
            onTap: () => utils.openGallery(context, index, images),
          ),
        );
      }).toList(),
    );
  }
}

class _FileImages extends StatelessWidget {
  const _FileImages({
    super.key,
    required this.images,
    this.forFocus = false,
  });

  final List<AssetEntity> images;
  final bool forFocus;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: images.map<StaggeredGridTile>((image) {
        final index = images.indexOf(image);
        final crossAxisCellCount = images.length % 2 != 0 && index == 0 ? 2 : 1;
        return StaggeredGridTile.count(
          crossAxisCellCount: crossAxisCellCount,
          mainAxisCellCount: 1,
          child: Stack(
            children: [
              Positioned.fill(
                child: FutureBuilder<File?>(
                  future: images[index].file,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done ||
                        !snapshot.hasData) {
                      return const SizedBox.expand();
                    }
                    final file = snapshot.data!;
                    return FilePhotoThumbnail(
                      key: Key('chat_message_${file.absolute}'),
                      heroTag: forFocus ? '_focused_${file.absolute}' : null,
                      galleryItem: file,
                      onTap: () => showToast('Image is sending'),
                    );
                  },
                ),
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
