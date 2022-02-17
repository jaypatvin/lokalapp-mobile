import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/conversation.dart';
import '../../models/lokal_images.dart';
import '../../utils/functions.utils.dart' as utils;
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class SharedMedia extends StatefulWidget {
  static const routeName = '/chat/view/profile/shared_media';
  const SharedMedia({Key? key, required this.conversations}) : super(key: key);

  final List<QueryDocumentSnapshot> conversations;

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
      final _conversation = Conversation.fromDocument(c);
      if (_conversation.media!.isNotEmpty) {
        images.addAll(_conversation.media!);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white30,
              child: GridView.builder(
                itemCount: _sharedMedia!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (ctx, index) {
                  return NetworkPhotoThumbnail(
                    galleryItem: _sharedMedia![index],
                    onTap: () =>
                        utils.openGallery(context, index, _sharedMedia),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
