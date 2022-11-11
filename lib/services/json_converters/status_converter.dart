import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/status.dart';

class StatusConverter implements JsonConverter<Status, String> {
  const StatusConverter();

  @override
  Status fromJson(String? status) {
    return Status.values.firstWhere(
      (e) => e.value == status,
      orElse: () => Status.enabled,
    );
  }

  @override
  String toJson(Status? status) => status?.value ?? Status.enabled.value;
}
