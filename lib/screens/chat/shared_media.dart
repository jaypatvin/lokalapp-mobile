import 'package:flutter/material.dart';

import '../../models/conversation.dart';
import '../../models/lokal_images.dart';
import '../../utils/functions.utils.dart' as utils;
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class SharedMedia extends StatefulWidget {
  static const routeName = '/chat/view/profile/shared_media';
  const SharedMedia({Key? key, required this.conversations}) : super(key: key);

  final List<Conversation> conversations;

  @override
  _SharedMediaState createState() => _SharedMediaState();
}

class _SharedMediaState extends State<SharedMedia> {
  List<LokalImages>? _sharedMedia;

  @override
  void initState() {
    super.initState();

    _sharedMedia = _getAllChatMedia();
  }

  List<LokalImages> _getAllChatMedia() {
    final images = <LokalImages>[];
    for (final c in widget.conversations) {
      if (c.media?.isNotEmpty ?? false) {
        images.addAll(c.media!);
      }
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Shared Media',
        titleStyle: const TextStyle(color: Colors.black),
        leadingColor: Colors.black,
        backgroundColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white30,
        child: GridView.builder(
          itemCount: _sharedMedia!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (ctx, index) {
            return NetworkPhotoThumbnail(
              galleryItem: _sharedMedia![index],
              onTap: () => utils.openGallery(context, index, _sharedMedia),
            );
          },
        ),
      ),
    );
  }
}
