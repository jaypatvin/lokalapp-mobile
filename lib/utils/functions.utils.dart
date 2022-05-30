import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:photo_manager/photo_manager.dart';

import '../models/app_navigator.dart';
import '../models/conversation.dart';
import '../models/lokal_images.dart';
import '../models/operating_hours.dart';
import '../models/order.dart';
import '../models/status.dart';
import '../models/timestamp_time_object.dart';
import '../routers/app_router.dart';
import '../widgets/photo_view_gallery/gallery/gallery_asset_photo_view.dart';
import '../widgets/photo_view_gallery/gallery/gallery_network_photo_view.dart';

void openInputGallery(
  BuildContext context,
  final int index,
  List<AssetEntity> galleryItems,
) {
  AppRouter.rootNavigatorKey.currentState?.push(
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
  AppRouter.rootNavigatorKey.currentState?.push(
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
      operatingHours.repeatUnit > 0 &&
      (operatingHours.startTime.isNotEmpty) &&
      (operatingHours.endTime.isNotEmpty) &&
      (operatingHours.repeatType.isNotEmpty) &&
      (operatingHours.startDates.isNotEmpty);
}

extension StringExtension on String {
  String capitalize() {
    if (this == 'null' || isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

DateTime createdAtFromJson(dynamic map) {
  if (map is Timestamp) {
    return map.toDate();
  } else if (map is String) {
    return DateFormat('yyyy-MM-dd').parse(map);
  }
  return TimestampObject.fromMap(map).toDateTime();
}

DateTime? nullableDateTimeFromJson(dynamic map) {
  try {
    if (map is Timestamp) {
      return map.toDate();
    } else if (map is String) {
      return DateFormat('yyyy-MM-dd').parse(map);
    } else if (map != null) {
      return TimestampObject.fromMap(map).toDateTime();
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Status statusFromJson(String? status) {
  return Status.values.firstWhere(
    (e) => e.value == status,
    orElse: () => Status.enabled,
  );
}

String statusToJson(Status? status) => status?.value ?? Status.enabled.value;

String dateTimeToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

String? nullableDateTimeToString(DateTime? date) {
  if (date != null) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  return null;
}

PaymentMethod? nullablePaymentMethodFromJson(String? value) {
  return PaymentMethod.values.firstWhereOrNull((e) => e.value == value);
}

String? nullablePaymentMethodToJson(PaymentMethod? method) => method?.value;

PaymentMethod paymentMethodFromJson(String? value) {
  return PaymentMethod.values.firstWhere(
    (e) => e.value == value,
    orElse: () => PaymentMethod.cod,
  );
}

String paymentMethodToJson(PaymentMethod? method) =>
    method?.value ?? PaymentMethod.cod.value;

MediaType mediaTypeFromJson(String json) => MediaType.values.firstWhere(
      (e) => e.value == json,
      orElse: () => MediaType.image,
    );

String mediaTypeToJson(MediaType type) => type.value;

/// Puts [element] between every element in [list].
///
/// Example:
///
///     final list1 = intersperse(2, <int>[]); // [];
///     final list2 = intersperse(2, [0]); // [0];
///     final list3 = intersperse(2, [0, 0]); // [0, 2, 0];
///
Iterable<T> intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterator.moveNext()) {
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}

/// Puts [element] between every element in [list] and at the bounds of [list].
///
/// Example:
///
///     final list1 = intersperseOuter(2, <int>[]); // [];
///     final list2 = intersperseOuter(2, [0]); // [2, 0, 2];
///     final list3 = intersperseOuter(2, [0, 0]); // [2, 0, 2, 0, 2];
///
Iterable<T> intersperseOuter<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterable.isNotEmpty) {
    yield element;
  }
  while (iterator.moveNext()) {
    yield iterator.current;
    yield element;
  }
}
