import 'package:json_annotation/json_annotation.dart';

import '../../lokal_images.dart';

part 'activity.request.g.dart';

@JsonSerializable()
class ActivityRequest {
  const ActivityRequest({
    required this.userId,
    this.message,
    this.images,
  });

  @JsonKey(required: true)
  final String userId;
  final String? message;
  final List<LokalImages>? images;

  factory ActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityRequestToJson(this);
}
