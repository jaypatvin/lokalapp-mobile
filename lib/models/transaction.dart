import 'dart:convert';

import 'package:flutter/foundation.dart';

// this is a mock model of the transactions for build purposes
class Transaction {
  String productName;
  int quantity;
  double price;
  Transaction({
    @required this.quantity,
    @required this.productName,
    @required this.price,
  });

  Transaction copyWith({
    String productName,
    int quantity,
    double price,
  }) {
    return Transaction(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() =>
      'Transaction(productName: $productName, quantity: $quantity, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.price == price;
  }

  @override
  int get hashCode => productName.hashCode ^ quantity.hashCode ^ price.hashCode;
}
