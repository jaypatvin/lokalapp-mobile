import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../utils/functions.utils.dart';
import '../../lokal_images.dart';
import '../../status.dart';

part 'product_update.request.g.dart';

@JsonSerializable()
class ProductUpdateRequest {
  const ProductUpdateRequest({
    this.name,
    this.description,
    this.basePrice,
    this.quantity,
    this.productCategory,
    this.status,
    this.canSubscribe,
    this.gallery,
  });

  final String? name;
  final String? description;
  final double? basePrice;
  final int? quantity;
  final String? productCategory;
  @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
  final Status? status;
  final bool? canSubscribe;
  final List<LokalImages>? gallery;

  Map<String, dynamic> toJson() => _$ProductUpdateRequestToJson(this);
  factory ProductUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductUpdateRequestFromJson(json);

  @override
  String toString() {
    return 'ProductUpdateRequest(name: $name, description: $description, '
        'basePrice: $basePrice, quantity: $quantity, '
        'productCategory: $productCategory, status: $status, '
        'canSubscribe: $canSubscribe, gallery: $gallery)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductUpdateRequest &&
        other.name == name &&
        other.description == description &&
        other.basePrice == basePrice &&
        other.quantity == quantity &&
        other.productCategory == productCategory &&
        other.status == status &&
        other.canSubscribe == canSubscribe &&
        listEquals(other.gallery, gallery);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        basePrice.hashCode ^
        quantity.hashCode ^
        productCategory.hashCode ^
        status.hashCode ^
        canSubscribe.hashCode ^
        gallery.hashCode;
  }
}
