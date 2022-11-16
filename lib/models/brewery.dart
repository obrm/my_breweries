import 'dart:convert';

class Brewery {
  final String id;
  final String name;
  final String type;
  final String street;
  final String city;
  final String state;
  final String country;

  Brewery({
    required this.id,
    required this.name,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
  });

  factory Brewery.fromMap(Map brewery) {
    return Brewery(
      id: brewery['id'],
      name: brewery['name'],
      type: brewery['brewery_type'],
      street: brewery['street'],
      city: brewery['city'],
      state: brewery['state'],
      country: brewery['country'],
    );
  }

  factory Brewery.fromJson(String brewery) {
    return jsonDecode(brewery);
  }

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "street": street,
      "city": city,
      "state": state,
      "country": country,
    };
  }
}
