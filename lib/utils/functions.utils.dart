import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:photo_manager/photo_manager.dart';

import '../models/app_navigator.dart';
import '../models/lokal_images.dart';
import '../models/operating_hours.dart';
import '../widgets/photo_view_gallery/gallery/gallery_asset_photo_view.dart';
import '../widgets/photo_view_gallery/gallery/gallery_network_photo_view.dart';

void openInputGallery(
  BuildContext context,
  final int index,
  List<AssetEntity> galleryItems,
) {
  Navigator.push(
    context,
    AppNavigator.appPageRoute(
      builder: (_) => GalleryAssetPhotoView(
        galleryItems: galleryItems,
        initialIndex: index,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    ),
  );
}

void openGallery(
  BuildContext context,
  final int index,
  final List<LokalImages>? galleryItems,
) {
  Navigator.push(
    context,
    AppNavigator.appPageRoute(
      builder: (_) => GalleryNetworkPhotoView(
        galleryItems: galleryItems,
        initialIndex: index,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    ),
  );
}

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm();
  return TimeOfDay.fromDateTime(format.parse(tod));
}

String getTimeOfDayString(TimeOfDay time) {
  final now = DateTime.now();
  final date = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  final timeOfDay = DateFormat('hh:mm a').format(date);

  return timeOfDay;
}

bool isValidOperatingHours(OperatingHours? operatingHours) {
  return operatingHours != null &&
      operatingHours.repeatUnit! > 0 &&
      (operatingHours.startTime?.isNotEmpty ?? false) &&
      (operatingHours.endTime?.isNotEmpty ?? false) &&
      (operatingHours.repeatType?.isNotEmpty ?? false) &&
      (operatingHours.startDates?.isNotEmpty ?? false);
}

extension StringExtension on String {
  String capitalize() {
    if (this == 'null' || isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
