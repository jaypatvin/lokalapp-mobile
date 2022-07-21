import 'package:json_annotation/json_annotation.dart';

import '../../../utils/functions.utils.dart';

part 'shop_summary.request.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class ShopSummaryRequest {
  const ShopSummaryRequest({
    required this.minDate,
    required this.maxDate,
  });

  @JsonKey(
    required: true,
    toJson: dateTimeToString,
    fromJson: dateTimeFromJson,
  )
  final DateTime minDate;
  @JsonKey(
    required: true,
    toJson: dateTimeToString,
    fromJson: dateTimeFromJson,
  )
  final DateTime maxDate;

  ShopSummaryRequest copyWith({
    String? shopId,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    return ShopSummaryRequest(
      minDate: minDate ?? this.minDate,
      maxDate: maxDate ?? this.maxDate,
    );
  }

  Map<String, dynamic> toJson() => _$ShopSummaryRequestToJson(this);

  factory ShopSummaryRequest.fromJson(Map<String, dynamic> json) =>
      _$ShopSummaryRequestFromJson(json);

  @override
  String toString() =>
      'ShopSummaryRequest(minDate: $minDate, maxDate: $maxDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopSummaryRequest &&
        other.minDate == minDate &&
        other.maxDate == maxDate;
  }

  @override
  int get hashCode => minDate.hashCode ^ maxDate.hashCode;
}
