import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  Address({
    required this.state,
    required this.subdivision,
    required this.city,
    required this.country,
    required this.zipCode,
    required this.barangay,
    required this.street,
  });
  @JsonKey(required: true)
  final String state;
  @JsonKey(required: true)
  final String subdivision;
  @JsonKey(required: true)
  final String city;
  @JsonKey(required: true)
  final String country;
  @JsonKey(required: true)
  final String zipCode;
  @JsonKey(required: true)
  final String barangay;
  @JsonKey(defaultValue: '')
  final String street;

  Address copyWith({
    String? state,
    String? subdivision,
    String? city,
    String? country,
    String? zipCode,
    String? barangay,
    String? street,
  }) {
    return Address(
      state: state ?? this.state,
      subdivision: subdivision ?? this.subdivision,
      city: city ?? this.city,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      barangay: barangay ?? this.barangay,
      street: street ?? this.street,
    );
  }

  Map<String, dynamic> toJson() => _$AddressToJson(this);
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  @override
  String toString() {
    return 'Address(state: $state, subdivision: $subdivision, city: $city, '
        'country: $country, zipCode: $zipCode, barangay: $barangay, '
        'street: $street)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.state == state &&
        other.subdivision == subdivision &&
        other.city == city &&
        other.country == country &&
        other.zipCode == zipCode &&
        other.barangay == barangay &&
        other.street == street;
  }

  @override
  int get hashCode {
    return state.hashCode ^
        subdivision.hashCode ^
        city.hashCode ^
        country.hashCode ^
        zipCode.hashCode ^
        barangay.hashCode ^
        street.hashCode;
  }
}
