import 'package:json_annotation/json_annotation.dart';

part 'comment.like.request.g.dart';

@JsonSerializable()
class CommentLikeRequest {
  const CommentLikeRequest({required this.userId});

  final String userId;

  Map<String, dynamic> toJson() => _$CommentLikeRequestToJson(this);
  factory CommentLikeRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentLikeRequestFromJson(json);
}
