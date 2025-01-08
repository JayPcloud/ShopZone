import '../utils/constants/strings.dart';

class Address {
  int? id;
  String country, name, streetAddress, state, city, phone;

  Address({
    this.id,
    required this.country,
    required this.name,
    required this.streetAddress,
    required this.state,
    required this.city,
    required this.phone,

});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json[Strings.dbAddressIdColumn],
      name: json[Strings.dbAddressNameColumn],
      country: json[Strings.dbAddressCountryColumn],
        streetAddress: json[Strings.dbAddressStreetColumn],
        state: json[Strings.dbAddressStateColumn],
        city: json[Strings.dbAddressCityColumn],
        phone: json[Strings.dbAddressPhoneColumn].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map[Strings.dbAddressNameColumn] = name;
    map[Strings.dbAddressCountryColumn] = country;
    map[Strings.dbAddressStreetColumn] = streetAddress;
    map[Strings.dbAddressStateColumn] = state;
    map[Strings.dbAddressCityColumn] = city;
    map[Strings.dbAddressPhoneColumn] = phone;

    return map;
  }

}