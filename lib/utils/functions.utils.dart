import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:intl/intl.dart' show DateFormat;

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

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}

String getTimeOfDayString(BuildContext context, TimeOfDay time) {
  String timeOfDay = TimeOfDay(
    hour: time.hour,
    minute: time.minute,
  ).replacing(hour: time.hourOfPeriod).format(context);
  String period = time.period == DayPeriod.am ? "AM" : "PM";

  return '$timeOfDay $period';
}
