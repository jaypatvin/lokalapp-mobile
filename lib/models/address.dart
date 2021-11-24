import 'dart:convert';

class Address {
  final String state;
  final String subdivision;
  final String city;
  final String country;
  final String zipCode;
  final String barangay;
  final String street;
  Address({
    required this.state,
    required this.subdivision,
    required this.city,
    required this.country,
    required this.zipCode,
    required this.barangay,
    required this.street,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'state': state,
      'subdivision': subdivision,
      'city': city,
      'country': country,
      'zip_code': zipCode,
      'barangay': barangay,
      'street': street,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      state: map['state'] ?? '',
      subdivision: map['subdivision'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      zipCode: map['zip_code'] ?? '',
      barangay: map['barangay'] ?? '',
      street: map['street'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));

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
