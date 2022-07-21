import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop_summary.g.dart';

@JsonSerializable()
class ProductSold {
  const ProductSold({
    required this.id,
    required this.name,
    required this.soldCount,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final int soldCount;

  ProductSold copyWith({
    String? id,
    String? name,
    int? soldCount,
  }) {
    return ProductSold(
      id: id ?? this.id,
      name: name ?? this.name,
      soldCount: soldCount ?? this.soldCount,
    );
  }

  Map<String, dynamic> toJson() => _$ProductSoldToJson(this);

  factory ProductSold.fromJson(Map<String, dynamic> json) =>
      _$ProductSoldFromJson(json);

  @override
  String toString() =>
      'ProductSold(id: $id, name: $name, soldCount: $soldCount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductSold &&
        other.id == id &&
        other.name == name &&
        other.soldCount == soldCount;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ soldCount.hashCode;
}

@JsonSerializable()
class ShopSummary {
  const ShopSummary({
    required this.totalEarnings,
    required this.productsSold,
  });

  @JsonKey(required: true, defaultValue: 0)
  final double totalEarnings;
  @JsonKey(required: true)
  final List<ProductSold> productsSold;

  ShopSummary copyWith({
    double? totalEarnings,
    List<ProductSold>? productsSold,
  }) {
    return ShopSummary(
      totalEarnings: totalEarnings ?? this.totalEarnings,
      productsSold: productsSold ?? this.productsSold,
    );
  }

  Map<String, dynamic> toJson() => _$ShopSummaryToJson(this);

  factory ShopSummary.fromJson(Map<String, dynamic> json) =>
      _$ShopSummaryFromJson(json);

  @override
  String toString() =>
      'ShopSummary(totalEarnings: $totalEarnings, productsSold: $productsSold)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopSummary &&
        other.totalEarnings == totalEarnings &&
        listEquals(other.productsSold, productsSold);
  }

  @override
  int get hashCode => totalEarnings.hashCode ^ productsSold.hashCode;
}
