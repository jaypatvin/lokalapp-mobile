// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import '../services/json_converters/status_converter.dart';
import 'lokal_images.dart';
import 'operating_hours.dart';
import 'status.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required bool archived,
    required double basePrice,
    required bool canSubscribe,
    required String communityId,
    @DateTimeConverter() required DateTime createdAt,
    required String description,
    required String name,
    required String productCategory,
    required int quantity,
    required String shopId,
    @StatusConverter() required Status status,
    required String userId,
    @JsonKey(readValue: _numRatingsReadValue, defaultValue: 0)
        required int numRatings,
    @JsonKey(readValue: _avgRatingReadValue, defaultValue: 0)
        required double avgRating,
    @Default([]) List<String> likes,
    @Default(OperatingHours()) OperatingHours availability,
    List<LokalImages>? gallery,
    @DateTimeOrNullConverter() DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  factory Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Product.fromJson({'id': doc.id, ...doc.data()!});
  }
}

int? _numRatingsReadValue(Map<dynamic, dynamic> map, String key) {
  return map['_meta']?['reviews_count'];
}

num? _avgRatingReadValue(Map<dynamic, dynamic> map, String key) {
  return map['_meta']?['average_rating'];
}
