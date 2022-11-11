import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import 'address.dart';

part 'community.freezed.dart';
part 'community.g.dart';

@freezed
class Community with _$Community {
  const factory Community({
    required String id,
    required String name,
    required Address address,
    @Default('') String profilePhoto,
    @Default(false) bool archived,
    required String coverPhoto,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeOrNullConverter() DateTime? updatedAt,
  }) = _Community;

  factory Community.fromJson(Map<String, dynamic> json) =>
      _$CommunityFromJson(json);

  factory Community.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Community.fromJson({'id': doc.id, ...doc.data()!});
  }
}
