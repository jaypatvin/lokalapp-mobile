import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';

part 'lokal_invite.freezed.dart';
part 'lokal_invite.g.dart';

@freezed
class LokalInvite with _$LokalInvite {
  /// The model for Lokal's [Invite Code].
  ///
  /// When checking if an Invite Code is claimed, only the [id] and
  /// [communityId] are supplied.
  const factory LokalInvite({
    required String id,
    required String communityId,
    String? updatedFrom,
    String? updatedBy,
    bool? claimed,
    String? inviter,
    @DateTimeOrNullConverter() DateTime? createdAt,
    String? inviteeEmail,
    String? status,
    String? code,
    bool? archived,
  }) = _LokalInvite;

  factory LokalInvite.fromJson(Map<String, dynamic> json) =>
      _$LokalInviteFromJson(json);
}
