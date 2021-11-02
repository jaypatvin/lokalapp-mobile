import 'dart:convert';

class LokalInvite {
  const LokalInvite({
    required this.id,
    required this.communityId,
  });

  final String id;
  final String communityId;

  LokalInvite copyWith({
    String? id,
    String? communityId,
  }) {
    return LokalInvite(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'community_id': communityId,
    };
  }

  factory LokalInvite.fromMap(Map<String, dynamic> map) {
    return LokalInvite(
      id: map['id'],
      communityId: map['community_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LokalInvite.fromJson(String source) =>
      LokalInvite.fromMap(json.decode(source));

  @override
  String toString() => 'LokalInvite(id: $id, communityId: $communityId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LokalInvite &&
        other.id == id &&
        other.communityId == communityId;
  }

  @override
  int get hashCode => id.hashCode ^ communityId.hashCode;
}
