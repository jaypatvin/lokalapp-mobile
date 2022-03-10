import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_code.g.dart';

enum BankType { bank, wallet }

extension BankTypeExtension on BankType {
  String get value => toString().split('.').last;
}

@JsonSerializable()
class BankCode {
  const BankCode({
    required this.id,
    required this.iconUrl,
    required this.name,
    required this.type,
  });

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String iconUrl;
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true, fromJson: _bankTypeFromJson, toJson: _bankTypeToJson)
  final BankType type;

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

  factory BankCode.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data();
    return BankCode.fromJson({'id': doc.id, ...map});
  }

  Map<String, dynamic> toJson() => _$BankCodeToJson(this);

  factory BankCode.fromJson(Map<String, dynamic> json) =>
      _$BankCodeFromJson(json);

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

BankType _bankTypeFromJson(String bankType) {
  return BankType.values.firstWhere(
    (e) => e.value == bankType,
    orElse: () => BankType.bank,
  );
}

String _bankTypeToJson(BankType type) => type.value;
