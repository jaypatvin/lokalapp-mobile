import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  const Report({
    required this.description,
  });

  @JsonKey(required: true)
  final String description;

  Report copyWith({
    String? description,
  }) {
    return Report(
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => _$ReportToJson(this);

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  @override
  String toString() => 'Report(description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Report && other.description == description;
  }

  @override
  int get hashCode => description.hashCode;
}
