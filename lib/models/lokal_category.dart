import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import '../services/json_converters/status_converter.dart';
import 'status.dart';

part 'lokal_category.freezed.dart';
part 'lokal_category.g.dart';

@freezed
class LokalCategory with _$LokalCategory {
  const factory LokalCategory({
    required String id,
    @DateTimeOrNullConverter() DateTime? updatedAt,
    @Default(false) bool archived,
    required String name,
    @DateTimeConverter() required DateTime createdAt,
    required String coverUrl,
    required String iconUrl,
    required String description,
    @StatusConverter() required Status status,
  }) = _LokalCategory;

  factory LokalCategory.fromJson(Map<String, dynamic> json) =>
      _$LokalCategoryFromJson(json);

  factory LokalCategory.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      LokalCategory.fromJson({'id': doc.id, ...doc.data()});
}
