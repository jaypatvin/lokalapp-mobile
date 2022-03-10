
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';

part 'lokal_invite.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  includeIfNull: false,
)
class LokalInvite {
  /// The model for Lokal's [Invite Code].
  ///
  /// When checking if an Invite Code is claimed, only the [id] and
  /// [communityId] are supplied.
  const LokalInvite({
    required this.id,
    required this.communityId,
    this.updatedFrom,
    this.updatedBy,
    this.claimed,
    this.inviter,
    this.createdAt,
    this.inviteeEmail,
    this.status,
    this.code,
    this.archived,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String communityId;

  final String? updatedFrom;
  final String? updatedBy;
  final bool? claimed;
  final String? inviter;
  @JsonKey(fromJson: nullableDateTimeFromJson)
  final DateTime? createdAt;
  final String? inviteeEmail;
  final String? status;
  final String? code;
  final bool? archived;

  LokalInvite copyWith({
    String? id,
    String? communityId,
    String? updatedFrom,
    String? updatedBy,
    bool? claimed,
    String? inviter,
    DateTime? createdAt,
    String? inviteeEmail,
    String? status,
    String? code,
    bool? archived,
  }) {
    return LokalInvite(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      updatedFrom: updatedFrom ?? this.updatedFrom,
      updatedBy: updatedBy ?? this.updatedBy,
      claimed: claimed ?? this.claimed,
      inviter: inviter ?? this.inviter,
      createdAt: createdAt ?? this.createdAt,
      inviteeEmail: inviteeEmail ?? this.inviteeEmail,
      status: status ?? this.status,
      code: code ?? this.code,
      archived: archived ?? this.archived,
    );
  }

  Map<String, dynamic> toJson() => _$LokalInviteToJson(this);

  factory LokalInvite.fromJson(Map<String, dynamic> json) =>
      _$LokalInviteFromJson(json);

  @override
  String toString() {
    return 'LokalInvite(id: $id, communityId: $communityId, '
        'updatedFrom: $updatedFrom, updatedBy: $updatedBy, claimed: $claimed, '
        'inviter: $inviter, createdAt: $createdAt, '
        'inviteeEmail: $inviteeEmail, status: $status, '
        'code: $code, archived: $archived)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LokalInvite &&
        other.id == id &&
        other.communityId == communityId &&
        other.updatedFrom == updatedFrom &&
        other.updatedBy == updatedBy &&
        other.claimed == claimed &&
        other.inviter == inviter &&
        other.createdAt == createdAt &&
        other.inviteeEmail == inviteeEmail &&
        other.status == status &&
        other.code == code &&
        other.archived == archived;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        communityId.hashCode ^
        updatedFrom.hashCode ^
        updatedBy.hashCode ^
        claimed.hashCode ^
        inviter.hashCode ^
        createdAt.hashCode ^
        inviteeEmail.hashCode ^
        status.hashCode ^
        code.hashCode ^
        archived.hashCode;
  }
}
