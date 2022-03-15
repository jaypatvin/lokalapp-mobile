import 'package:json_annotation/json_annotation.dart';

part 'product_review.request.g.dart';

@JsonSerializable()
class ProductReviewRequest {
  const ProductReviewRequest({
    required this.orderId,
    required this.rating,
    this.message,
  });

  final String? message;
  final String orderId;
  final int rating;

  Map<String, dynamic> toJson() => _$ProductReviewRequestToJson(this);
  factory ProductReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewRequestFromJson(json);
}
