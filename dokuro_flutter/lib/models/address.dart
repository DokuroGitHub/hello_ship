import 'dart:math';

class Address {
  late String id;
  late String details;
  late String street;
  late String district;
  late String city;
  late Point? location;

  Address({
    this.id = '',
    this.details = '',
    this.street = '',
    this.district = '',
    this.city = '',
    this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] ?? '',
        details: json['details'] ?? '',
        street: json['street'] ?? '',
        district: json['district'] ?? '',
        city: json['city'] ?? '',
        location:
            json['location']?['x'] != null && json['location']?['y'] != null
                ? Point(json['location']['x'], json['location']['y'])
                : null,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'Address',
        'id': id,
        'details': details,
        'street': street,
        'district': district,
        'city': city,
        'location': location,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertAddressToMap(Address? address) {
  if (address == null) {
    return null;
  }
  return address.toJson();
}

Address? convertMapToAddress(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Address.fromJson(json);
}

List<Map<String, dynamic>> convertAddressesToMaps(List<Address>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<Address> convertMapsToAddresses(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => Address.fromJson(e)).toList();
}
