import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserProduct extends ChangeNotifier {
  String name;
  String userId;
  String communityId;
  String description;
  String productPhoto;
  String productCategory;
  String productPrice;
  String inventoryStock;
  // Map deliveryOptions;

  UserProduct({
    this.productCategory,
    this.productPrice,
    this.description,
    this.name,
    this.userId,
    this.inventoryStock,
    this.communityId,
    this.productPhoto,
    // this.deliveryOptions,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'community_id': communityId,
      'name': name,
      'description': description,
      'product_photo': productPhoto,
      'product_category': productCategory,
      'product_price': productPrice,
      // 'delivery_options': deliveryOptions,
      'inventoryStock': inventoryStock,
    };
  }

  factory UserProduct.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserProduct(
      userId: map['user_id'],
      communityId: map['community_id'],
      name: map['name'],
      description: map['description'],
      productPhoto: map['product_photo'],
      productCategory: map['product_category'],
      productPrice: map['product_price'],
      // deliveryOptions: map['delivery_options'],
      inventoryStock: map['inventory_stock'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProduct.fromJson(String source) =>
      UserProduct.fromMap(json.decode(source));

  factory UserProduct.fromDocument(DocumentSnapshot doc) {
    return UserProduct(
      userId: doc.data()['user_id'],
      communityId: doc.data()['community_id'],
      name: doc.data()['name'],
      description: doc.data()['description'],
      productPhoto: doc.data()['product_photo'],
      productPrice: doc.data()['product_price'],
      // deliveryOptions: doc.data()['delivery_options'],
      inventoryStock: doc.data()['inventory_stock'],
    );
  }
}
