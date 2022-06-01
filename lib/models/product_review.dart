import 'package:json_annotation/json_annotation.dart';

part 'product_review.g.dart';

@JsonSerializable()
class ProductReview {
  const ProductReview({
    required this.orderId,
    required this.userId,
    required this.rating,
    this.message,
  });

  @JsonKey(required: true)
  final String orderId;
  @JsonKey(required: true)
  final String userId;
  @JsonKey(required: true)
  final int rating;

  final String? message;

  ProductReview copyWith({
    String? orderId,
    String? userId,
    int? rating,
    String? message,
  }) {
    return ProductReview(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$ProductReviewToJson(this);
  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);

  @override
  String toString() {
    return 'ProductReview(orderId: $orderId, userId: $userId, rating: $rating, '
        'message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductReview &&
        other.orderId == orderId &&
        other.userId == userId &&
        other.rating == rating &&
        other.message == message;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        userId.hashCode ^
        rating.hashCode ^
        message.hashCode;
  }
}
