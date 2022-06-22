import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';

part 'product_review.g.dart';

@JsonSerializable()
class ProductReview {
  const ProductReview({
    required this.productId,
    required this.orderId,
    required this.userId,
    required this.rating,
    required this.createdAt,
    this.updatedAt,
    this.message,
  });

  @JsonKey(required: true)
  final String productId;
  @JsonKey(required: true)
  final String orderId;
  @JsonKey(required: true)
  final String userId;
  @JsonKey(required: true)
  final int rating;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(
    fromJson: nullableDateTimeFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime? updatedAt;
  final String? message;

  ProductReview copyWith({
    String? productId,
    String? orderId,
    String? userId,
    int? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? message,
  }) {
    return ProductReview(
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$ProductReviewToJson(this);
  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);

  @override
  String toString() {
    return 'ProductReview(productId: $productId, orderId: $orderId, '
        'userId: $userId, rating: $rating, createdAt: $createdAt, '
        'updatedAt: $updatedAt, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductReview &&
        other.productId == productId &&
        other.orderId == orderId &&
        other.userId == userId &&
        other.rating == rating &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.message == message;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        orderId.hashCode ^
        userId.hashCode ^
        rating.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        message.hashCode;
  }
}
