import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../utils/functions.utils.dart';
import '../../lokal_images.dart';
import '../../status.dart';
import '../shop/operating_hours.request.dart';

part 'product_create.request.g.dart';

@JsonSerializable()
class ProductCreateRequest {
  const ProductCreateRequest({
    required this.name,
    required this.description,
    required this.shopId,
    required this.basePrice,
    required this.quantity,
    required this.productCategory,
    required this.status,
    required this.canSubscribe,
    this.gallery,
    this.availability,
  });

  final String name;
  final String description;
  final String shopId;
  final double basePrice;
  final int quantity;
  final String productCategory;
  @JsonKey(toJson: statusToJson, fromJson: statusFromJson)
  final Status status;
  @JsonKey(defaultValue: true)
  final bool canSubscribe;
  final List<LokalImages>? gallery;
  final OperatingHoursRequest? availability;

  Map<String, dynamic> toJson() => _$ProductCreateRequestToJson(this);
  factory ProductCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductCreateRequestFromJson(json);

  ProductCreateRequest copyWith({
    String? name,
    String? description,
    String? shopId,
    double? basePrice,
    int? quantity,
    String? productCategory,
    Status? status,
    bool? canSubscribe,
    List<LokalImages>? gallery,
    OperatingHoursRequest? availability,
  }) {
    return ProductCreateRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      shopId: shopId ?? this.shopId,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      productCategory: productCategory ?? this.productCategory,
      status: status ?? this.status,
      canSubscribe: canSubscribe ?? this.canSubscribe,
      gallery: gallery ?? this.gallery,
      availability: availability ?? this.availability,
    );
  }

  @override
  String toString() {
    return 'ProductCreateRequest(name: $name, description: $description, '
        'shopId: $shopId, basePrice: $basePrice, quantity: $quantity, '
        'productCategory: $productCategory, status: $status, '
        'canSubscribe: $canSubscribe, gallery: $gallery, '
        'availability: $availability)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductCreateRequest &&
        other.name == name &&
        other.description == description &&
        other.shopId == shopId &&
        other.basePrice == basePrice &&
        other.quantity == quantity &&
        other.productCategory == productCategory &&
        other.status == status &&
        other.canSubscribe == canSubscribe &&
        listEquals(other.gallery, gallery) &&
        other.availability == availability;
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
        canSubscribe.hashCode ^
        gallery.hashCode ^
        availability.hashCode;
  }
}
