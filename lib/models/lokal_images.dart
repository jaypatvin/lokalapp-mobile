import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lokal_images.freezed.dart';
part 'lokal_images.g.dart';

abstract class ILokalImage {
  const ILokalImage({required this.url, required this.order});

  final String url;
  final int order;
}

@freezed
class LokalImages with _$LokalImages implements ILokalImage {
  const factory LokalImages({
    required String url,
    @Default(0) int order,
  }) = _LokalImages;

  factory LokalImages.fromJson(Map<String, dynamic> json) =>
      _$LokalImagesFromJson(json);
}
