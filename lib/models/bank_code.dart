import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum BankType { bank, wallet }

extension BankTypeExtension on BankType {
  String get value => toString().split('.').last;

  BankType getFromValue() {
    return BankType.bank;
  }
}

class BankCode {
  final String id;
  final String iconUrl;
  final String name;
  final BankType type;
  const BankCode({
    required this.id,
    required this.iconUrl,
    required this.name,
    required this.type,
  });

  BankCode copyWith({
    String? id,
    String? iconUrl,
    String? name,
    BankType? type,
  }) {
    return BankCode(
      id: id ?? this.id,
      iconUrl: iconUrl ?? this.iconUrl,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon_url': iconUrl,
      'name': name,
      'type': type.value,
    };
  }

  factory BankCode.fromMap(Map<String, dynamic> map) {
    return BankCode(
      id: map['id'],
      iconUrl: map['icon_url'] ?? '',
      name: map['name'],
      type: BankType.values.firstWhere(
        (type) => type.value == map['type'],
        orElse: () => BankType.bank,
      ),
    );
  }

  factory BankCode.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data();
    return BankCode(
      id: doc.id,
      iconUrl: map['icon_url'] ?? '',
      name: map['name'],
      type: BankType.values.firstWhere(
        (type) => type.value == map['type'],
        orElse: () => BankType.bank,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BankCode.fromJson(String source) =>
      BankCode.fromMap(json.decode(source));

  @override
  String toString() =>
      'BankCode(id: $id, iconUrl: $iconUrl, name: $name, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankCode &&
        other.id == id &&
        other.iconUrl == iconUrl &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode =>
      id.hashCode ^ iconUrl.hashCode ^ name.hashCode ^ type.hashCode;
}
