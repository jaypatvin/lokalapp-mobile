import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'lokal_images.dart';

class UserProduct extends ChangeNotifier {
  String id;
  String name;
  String description;
  String shopId;
  String userId;
  String communityId;
  double basePrice;
  int quantity;
  String productCategory;
  String productPhoto;
  String status;
  List<LokalImages> gallery;
  UserProduct({
    this.id,
    this.name,
    this.description,
    this.shopId,
    this.userId,
    this.communityId,
    this.basePrice,
    this.quantity,
    this.productCategory,
    this.productPhoto,
    this.status,
    this.gallery,
  });

  UserProduct copyWith({
    String id,
    String name,
    String description,
    String shopId,
    String userId,
    String communityId,
    double basePrice,
    int quantity,
    String productCategory,
    String productPhoto,
    String status,
    List<LokalImages> gallery,
  }) {
    return UserProduct(
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
      'gallery': gallery?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory UserProduct.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserProduct(
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
      gallery: List<LokalImages>.from(
          map['gallery']?.map((x) => LokalImages.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProduct.fromJson(String source) =>
      UserProduct.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProduct(id: $id, name: $name, description: $description, shopId: $shopId, userId: $userId, communityId: $communityId, basePrice: $basePrice, quantity: $quantity, productCategory: $productCategory, productPhoto: $productPhoto, status: $status, gallery: $gallery)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserProduct &&
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
        listEquals(o.gallery, gallery);
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
        gallery.hashCode;
  }
}
