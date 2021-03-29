import 'dart:convert';

class LokalImages {
  final String url;
  final int order;
  LokalImages({
    this.url,
    this.order,
  });

  LokalImages copyWith({
    String url,
    int order,
  }) {
    return LokalImages(
      url: url ?? this.url,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'order': order,
    };
  }

  factory LokalImages.fromMap(Map<String, dynamic> map) {
    return LokalImages(
      url: map['url'],
      order: map['order'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LokalImages.fromJson(String source) =>
      LokalImages.fromMap(json.decode(source));

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
