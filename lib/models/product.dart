import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'lokal_images.dart';
import 'operating_hours.dart';
import 'status.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.shopId,
    required this.userId,
    required this.communityId,
    required this.basePrice,
    required this.quantity,
    required this.productCategory,
    required this.status,
    required this.archived,
    required this.canSubscribe,
    required this.createdAt,
    required this.updatedAt,
    required this.numRatings,
    required this.avgRating,
    required this.description,
    this.availability = const OperatingHours(),
    this.likes = const [],
    this.gallery,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final bool archived;
  // @JsonKey(defaultValue: OperatingHours())
  final OperatingHours availability;
  @JsonKey(required: true)
  final double basePrice;
  @JsonKey(required: true)
  final bool canSubscribe;
  @JsonKey(required: true)
  final String communityId;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(required: true)
  final String description;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final String productCategory;
  @JsonKey(required: true)
  final int quantity;
  @JsonKey(required: true)
  final String shopId;
  @JsonKey(required: true, fromJson: statusFromJson, toJson: statusToJson)
  final Status status;
  @JsonKey(required: true)
  final String userId;

  @JsonKey(readValue: _numRatingsReadValue, defaultValue: 0)
  final int numRatings;
  @JsonKey(readValue: _avgRatingReadValue, defaultValue: 0)
  final double avgRating;
  final List<String> likes;

  final List<LokalImages>? gallery;
  @JsonKey(
    fromJson: nullableDateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime? updatedAt;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? shopId,
    String? userId,
    String? communityId,
    double? basePrice,
    int? quantity,
    String? productCategory,
    String? productPhoto,
    Status? status,
    List<LokalImages>? gallery,
    OperatingHours? availability,
    bool? archived,
    bool? canSubscribe,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? numRatings,
    double? avgRating,
    String? updatedFrom,
    List<String>? likes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shopId: shopId ?? this.shopId,
      userId: userId ?? this.userId,
      communityId: communityId ?? this.communityId,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      productCategory: productCategory ?? this.productCategory,
      status: status ?? this.status,
      gallery: gallery ?? this.gallery,
      availability: availability ?? this.availability,
      archived: archived ?? this.archived,
      canSubscribe: canSubscribe ?? this.canSubscribe,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      numRatings: numRatings ?? this.numRatings,
      avgRating: avgRating ?? this.avgRating,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  factory Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Product.fromJson({'id': doc.id, ...doc.data()!});
  }

  @override
  String toString() {
    return 'UserProduct(id: $id, name: $name, description: $description, '
        'shopId: $shopId, userId: $userId, communityId: $communityId, '
        'basePrice: $basePrice, quantity: $quantity, productCategory: '
        '$productCategory, status: $status, '
        'gallery: $gallery, availability: $availability, archived: $archived '
        'canSubscribe: $canSubscribe, createdAt: $createdAt, '
        'updatedAt: $updatedAt, numRatings: $numRatings, avgRating: $avgRating, '
        'likes: $likes)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Product &&
        o.id == id &&
        o.name == name &&
        o.description == description &&
        o.shopId == shopId &&
        o.userId == userId &&
        o.communityId == communityId &&
        o.basePrice == basePrice &&
        o.quantity == quantity &&
        o.productCategory == productCategory &&
        o.status == status &&
        o.archived == archived &&
        listEquals(o.gallery, gallery) &&
        o.availability == availability &&
        o.canSubscribe == canSubscribe &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.numRatings == numRatings &&
        o.avgRating == avgRating &&
        listEquals(o.likes, likes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        shopId.hashCode ^
        userId.hashCode ^
        communityId.hashCode ^
        basePrice.hashCode ^
        quantity.hashCode ^
        productCategory.hashCode ^
        status.hashCode ^
        archived.hashCode ^
        gallery.hashCode ^
        availability.hashCode ^
        canSubscribe.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        numRatings.hashCode ^
        avgRating.hashCode ^
        likes.hashCode;
  }
}

int? _numRatingsReadValue(Map<dynamic, dynamic> map, String key) {
  return map['_meta']?['reviews_count'];
}

num? _avgRatingReadValue(Map<dynamic, dynamic> map, String key) {
  return map['_meta']?['average_rating'];
}
