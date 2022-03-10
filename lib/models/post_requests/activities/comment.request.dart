import 'package:json_annotation/json_annotation.dart';

import '../../lokal_images.dart';

part 'comment.request.g.dart';

@JsonSerializable()
class CommentRequest {
  const CommentRequest({
    required this.userId,
    this.message,
    this.images,
  });

  final String userId;
  final String? message;
  final List<LokalImages>? images;

  Map<String, dynamic> toJson() => _$CommentRequestToJson(this);
  factory CommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentRequestFromJson(json);
}
