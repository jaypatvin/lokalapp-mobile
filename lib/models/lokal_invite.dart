import 'dart:convert';

import 'timestamp_time_object.dart';

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

  final String id;
  final String communityId;

  final String? updatedFrom;
  final String? updatedBy;
  final bool? claimed;
  final String? inviter;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'community_id': communityId,
      'updated_from': updatedFrom,
      'updated_by': updatedBy,
      'claimed': claimed,
      'inviter': inviter,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'invitee_email': inviteeEmail,
      'status': status,
      'code': code,
      'archived': archived,
    };
  }

  factory LokalInvite.fromMap(Map<String, dynamic> map) {
    return LokalInvite(
      id: map['id'],
      communityId: map['community_id'],
      updatedFrom: map['updated_from'],
      updatedBy: map['updated_by'],
      claimed: map['claimed'],
      inviter: map['inviter'],
      createdAt: map['created_at'] != null
          ? TimestampObject.fromMap(map['created_at']).toDateTime()
          : null,
      inviteeEmail: map['invitee_email'],
      status: map['status'],
      code: map['code'],
      archived: map['archived'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LokalInvite.fromJson(String source) =>
      LokalInvite.fromMap(json.decode(source));

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
