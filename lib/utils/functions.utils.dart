import 'package:flutter/material.dart';
import 'package:lokalapp/models/timestamp_time_object.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../models/operating_hours.dart';

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
  final format = DateFormat.jm();
  return TimeOfDay.fromDateTime(format.parse(tod));
}

String getTimeOfDayString(BuildContext context, TimeOfDay time) {
  String timeOfDay = TimeOfDay(
    hour: time.hour,
    minute: time.minute,
  ).replacing(hour: time.hourOfPeriod).format(context);
  String period = time.period == DayPeriod.am ? "AM" : "PM";

  return "$timeOfDay $period";
}

bool isValidOperatingHours(OperatingHours operatingHours) {
  return operatingHours != null &&
      operatingHours.startTime.isNotEmpty &&
      operatingHours.endTime.isNotEmpty &&
      operatingHours.repeatUnit > 0 &&
      operatingHours.repeatType.isNotEmpty &&
      operatingHours.startDates.isNotEmpty;
}

extension StringExtension on String {
  String capitalize() {
    if (this == "null" || isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension TimestampObjectExtension on TimestampObject {
  DateTime toDateTime() => DateTime.fromMicrosecondsSinceEpoch(
      this.seconds * 1000000 + this.nanoseconds ~/ 1000);
}
