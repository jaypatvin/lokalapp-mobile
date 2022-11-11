import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';

part 'product_review.freezed.dart';
part 'product_review.g.dart';

@freezed
class ProductReview with _$ProductReview {
  const factory ProductReview({
    required String productId,
    required String orderId,
    required String userId,
    required int rating,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeOrNullConverter() DateTime? updatedAt,
    String? message,
  }) = _ProductReview;

  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);
}
