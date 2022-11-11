import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../models/timestamp_time_object.dart';

class DateTimeConverter implements JsonConverter<DateTime, dynamic> {
  const DateTimeConverter();

  @override
  DateTime fromJson(dynamic response) {
    if (response is Timestamp) {
      return response.toDate();
    } else if (response is String) {
      return DateFormat('yyyy-MM-dd').parse(response);
    }
    return TimestampObject.fromMap(response).toDateTime();
  }

  @override
  String? toJson(DateTime? date) {
    if (date != null) {
      return DateFormat('yyyy-MM-dd').format(date);
    }
    return null;
  }
}

class DateTimeOrNullConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeOrNullConverter();

  @override
  DateTime? fromJson(dynamic response) {
    if (response == null) {
      return null;
    } else if (response is Timestamp) {
      return response.toDate();
    } else if (response is String) {
      return DateFormat('yyyy-MM-dd').parse(response);
    }
    return TimestampObject.fromMap(response).toDateTime();
  }

  @override
  String? toJson(DateTime? date) {
    if (date != null) {
      return DateFormat('yyyy-MM-dd').format(date);
    }
    return null;
  }
}
