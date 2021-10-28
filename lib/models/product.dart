import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'timestamp_time_object.dart';

import 'lokal_images.dart';
import 'operating_hours.dart';

class Product {
  String id;
  String name;
  String? description;
  String shopId;
  String userId;
  String communityId;
  double basePrice;
  int quantity;
  String productCategory;
  String? productPhoto;
  String status;
  bool archived;
  bool canSubscribe;
  OperatingHours? availability;
  List<LokalImages>? gallery;
  DateTime createdAt;
  Product({
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
    this.description,
    this.productPhoto,
    this.gallery,
    this.availability,
  });

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
    String? status,
    List<LokalImages>? gallery,
    OperatingHours? availability,
    bool? archived,
    bool? canSubscribe,
    DateTime? createdAt,
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
      productPhoto: productPhoto ?? this.productPhoto,
      status: status ?? this.status,
      gallery: gallery ?? this.gallery,
      availability: availability ?? this.availability,
      archived: archived ?? this.archived,
      canSubscribe: canSubscribe ?? this.canSubscribe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shop_id': shopId,
      'user_id': userId,
      'community_id': communityId,
      'base_price': basePrice,
      'quantity': quantity,
      'product_category': productCategory,
      'product_photo': productPhoto,
      'status': status,
      'gallery': gallery?.map((x) => x.toMap()).toList(),
      'availability': availability?.toMap(),
      'archived': archived,
      'can_subscribe': canSubscribe,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      shopId: map['shop_id'],
      userId: map['user_id'],
      communityId: map['community_id'],
      basePrice: map['base_price'] == null ? 0.0 : map['base_price'].toDouble(),
      quantity: map['quantity'],
      productCategory: map['product_category'],
      productPhoto: map['product_photo'],
      status: map['status'],
      archived: map['archived'],
      canSubscribe: map['can_subscribe'] ?? true,
      createdAt: TimestampObject.fromMap(map['created_at']).toDateTime(),
      gallery: map['gallery'] == null
          ? <LokalImages>[]
          : List<LokalImages>.from(
              map['gallery']?.map((x) => LokalImages.fromMap(x))),
      availability: (map['availability'] != null
          ? OperatingHours.fromMap(map['availability'])
          : <LokalImages>[]) as OperatingHours?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProduct(id: $id, name: $name, description: $description, '
        'shopId: $shopId, userId: $userId, communityId: $communityId, '
        'basePrice: $basePrice, quantity: $quantity, productCategory: '
        '$productCategory, productPhoto: $productPhoto, status: $status, '
        'gallery: $gallery, availability: $availability, archived: $archived '
        'canSubscribe: $canSubscribe, createdAt: $createdAt)';
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
        o.productPhoto == productPhoto &&
        o.status == status &&
        o.archived == archived &&
        listEquals(o.gallery, gallery) &&
        o.availability == availability &&
        o.canSubscribe == canSubscribe &&
        o.createdAt == createdAt;
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
        productPhoto.hashCode ^
        status.hashCode ^
        archived.hashCode ^
        gallery.hashCode ^
        availability.hashCode ^
        canSubscribe.hashCode ^
        createdAt.hashCode;
  }
}
