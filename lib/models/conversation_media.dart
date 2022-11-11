import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/media_type_converter.dart';
import 'lokal_images.dart';

part 'conversation_media.freezed.dart';
part 'conversation_media.g.dart';

enum MediaType { image, audio, video }

extension MediaTypeExtension on MediaType {
  String get value {
    switch (this) {
      case MediaType.audio:
        return 'audio';
      case MediaType.image:
        return 'image';
      case MediaType.video:
        return 'video';
    }
  }
}

@freezed
class ConversationMedia with _$ConversationMedia implements ILokalImage {
  const factory ConversationMedia({
    required String url,
    @Default(0) int order,
    @MediaTypeConverter() required MediaType type,
  }) = _ConversationMedia;

  @override
  factory ConversationMedia.fromJson(Map<String, dynamic> json) =>
      _$ConversationMediaFromJson(json);
}
