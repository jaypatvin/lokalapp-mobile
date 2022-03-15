import 'package:json_annotation/json_annotation.dart';

part 'lokal_images.g.dart';

@JsonSerializable()
class LokalImages {
  const LokalImages({
    required this.url,
    required this.order,
  });

  final String url;
  final int order;

  LokalImages copyWith({
    String? url,
    int? order,
  }) {
    return LokalImages(
      url: url ?? this.url,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() => _$LokalImagesToJson(this);
  factory LokalImages.fromJson(Map<String, dynamic> json) =>
      _$LokalImagesFromJson(json);

  @override
  String toString() => 'LokalImages(url: $url, order: $order)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LokalImages && other.url == url && other.order == order;
  }

  @override
  int get hashCode => url.hashCode ^ order.hashCode;
}
