import 'package:json_annotation/json_annotation.dart';

part 'invite.request.g.dart';

@JsonSerializable()
class InviteRequest {
  const InviteRequest({
    required this.userId,
    required this.code,
  });

  @JsonKey(required: true)
  final String code;

  @JsonKey(required: true)
  final String userId;

  factory InviteRequest.fromJson(Map<String, dynamic> json) =>
      _$InviteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InviteRequestToJson(this);
}
