import 'dart:convert';
import 'package:flutter/cupertino.dart';

class ProductGallery {
  String url;
  int order;
  ProductGallery({
    this.url,
    this.order,
  });

  ProductGallery copyWith({
    String url,
    int order,
  }) {
    return ProductGallery(
      url: url ?? this.url,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'order': order,
    };
  }

  factory ProductGallery.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProductGallery(
      url: map['url'],
      order: map['order'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductGallery.fromJson(String source) =>
      ProductGallery.fromMap(json.decode(source));

  @override
  String toString() => 'ProductGallery(url: $url, order: $order)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductGallery && o.url == url && o.order == order;
  }

  @override
  int get hashCode => url.hashCode ^ order.hashCode;
}

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
  ProductGallery gallery;
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
    ProductGallery gallery,
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
      'shopId': shopId,
      'userId': userId,
      'communityId': communityId,
      'basePrice': basePrice,
      'quantity': quantity,
      'productCategory': productCategory,
      'productPhoto': productPhoto,
      'status': status,
      'gallery': gallery?.toMap(),
    };
  }

  factory UserProduct.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserProduct(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      shopId: map['shopId'],
      userId: map['userId'],
      communityId: map['communityId'],
      basePrice: map['basePrice'],
      quantity: map['quantity'],
      productCategory: map['productCategory'],
      productPhoto: map['productPhoto'],
      status: map['status'],
      gallery: ProductGallery.fromMap(map['gallery']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProduct.fromJson(String source) => UserProduct.fromMap(json.decode(source));

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
      o.gallery == gallery;
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
