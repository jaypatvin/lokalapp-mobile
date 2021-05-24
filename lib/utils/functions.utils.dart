import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/lokal_images.dart';
import '../widgets/photo_view_gallery/gallery/gallery_asset_photo_view.dart';
import '../widgets/photo_view_gallery/gallery/gallery_network_photo_view.dart';

void openInputGallery(
  BuildContext context,
  final int index,
  List<AssetEntity> galleryItems,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryAssetPhotoView(
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
