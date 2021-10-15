import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'lokal_images.dart';

class UserProductPost extends ChangeNotifier {
  String? name;
  String? description;
  String? shopId;
  double? basePrice;
  int? quantity;
  String? productCategory;
  String? status;
  List<LokalImages>? gallery;
  UserProductPost({
    this.name,
    this.description,
    this.shopId,
    this.basePrice,
    this.quantity,
    this.productCategory,
    this.status,
    this.gallery,
  });

  UserProductPost copyWith({
    String? name,
    String? description,
    String? shopId,
    double? basePrice,
    int? quantity,
    String? productCategory,
    String? status,
    List<LokalImages>? gallery,
  }) {
    return UserProductPost(
      name: name ?? this.name,
      description: description ?? this.description,
      shopId: shopId ?? this.shopId,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      productCategory: productCategory ?? this.productCategory,
      status: status ?? this.status,
      gallery: gallery ?? this.gallery,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'shop_id': shopId,
      'base_price': basePrice,
      'quantity': quantity,
      'product_category': productCategory,
      'status': status,
      'gallery': gallery?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserProductPost.fromMap(Map<String, dynamic> map) {
    return UserProductPost(
      name: map['name'],
      description: map['description'],
      shopId: map['shop_id'],
      basePrice: map['base_price'],
      quantity: map['quantity'],
      productCategory: map['product_category'],
      status: map['status'],
      gallery: List<LokalImages>.from(
          map['gallery']?.map((x) => LokalImages.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProductPost.fromJson(String source) =>
      UserProductPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProductPost(name: $name, description: $description, shopId: $shopId, basePrice: $basePrice, quantity: $quantity, productCategory: $productCategory, status: $status, gallery: $gallery)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserProductPost &&
        o.name == name &&
        o.description == description &&
        o.shopId == shopId &&
        o.basePrice == basePrice &&
        o.quantity == quantity &&
        o.productCategory == productCategory &&
        o.status == status &&
        listEquals(o.gallery, gallery);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        shopId.hashCode ^
        basePrice.hashCode ^
        quantity.hashCode ^
        productCategory.hashCode ^
        status.hashCode ^
        gallery.hashCode;
  }
}
