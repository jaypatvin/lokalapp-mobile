import 'package:json_annotation/json_annotation.dart';

part 'order_review.request.g.dart';

@JsonSerializable()
class OrderReviewRequest {
  const OrderReviewRequest({required this.rating, this.message});

  final String? message;
  @JsonKey(required: true)
  final int rating;

  Map<String, dynamic> toJson() => _$OrderReviewRequestToJson(this);
  factory OrderReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderReviewRequestFromJson(json);
}
