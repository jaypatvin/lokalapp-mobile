import 'dart:convert';

class TimestampObject {
  int seconds;
  int nanoseconds;
  TimestampObject({
    this.seconds,
    this.nanoseconds,
  });

  TimestampObject copyWith({
    int seconds,
    int nanoseconds,
  }) {
    return TimestampObject(
      seconds: seconds ?? this.seconds,
      nanoseconds: nanoseconds ?? this.nanoseconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_seconds': seconds,
      '_nanoseconds': nanoseconds,
    };
  }

  factory TimestampObject.fromMap(Map<String, dynamic> map) {
    return TimestampObject(
      seconds: map['_seconds'],
      nanoseconds: map['_nanoseconds'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TimestampObject.fromJson(String source) =>
      TimestampObject.fromMap(json.decode(source));

  @override
  String toString() =>
      'TimestampObject(seconds: $seconds, nanoseconds: $nanoseconds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimestampObject &&
        other.seconds == seconds &&
        other.nanoseconds == nanoseconds;
  }

  @override
  int get hashCode => seconds.hashCode ^ nanoseconds.hashCode;
}

extension TimestampObjectExtension on TimestampObject {
  DateTime toDateTime() => DateTime.fromMicrosecondsSinceEpoch(
      this.seconds * 1000000 + this.nanoseconds ~/ 1000);
}
