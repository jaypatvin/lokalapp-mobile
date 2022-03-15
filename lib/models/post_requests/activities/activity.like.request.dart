import 'package:json_annotation/json_annotation.dart';

part 'activity.like.request.g.dart';

@JsonSerializable()
class ActivityLikeRequest {
  const ActivityLikeRequest({required this.userId});
  final String userId;

  factory ActivityLikeRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivityLikeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityLikeRequestToJson(this);
}
