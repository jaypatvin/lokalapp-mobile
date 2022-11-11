import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/conversation_media.dart';

class MediaTypeConverter implements JsonConverter<MediaType?, String> {
  const MediaTypeConverter();

  @override
  MediaType fromJson(String json) => MediaType.values.firstWhere(
        (e) => e.value == json,
        orElse: () => MediaType.image,
      );

  @override
  String toJson(MediaType? type) => type?.value ?? MediaType.image.value;
}
