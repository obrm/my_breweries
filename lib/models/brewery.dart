class Brewery {
  final String id;
  final String name;
  final String type;
  final String street;
  final String city;
  final String state;
  final String country;
  bool isFavored;

  Brewery({
    required this.id,
    required this.name,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.isFavored,
  });

  factory Brewery.fromJson(Map<String, dynamic> brewery) {
    return Brewery(
      id: brewery['id'] ?? '',
      name: brewery['name'] ?? '',
      type: brewery['brewery_type'] ?? '',
      street: brewery['street'] ?? '',
      city: brewery['city'] ?? '',
      state: brewery['state'] ?? '',
      country: brewery['country'] ?? '',
      isFavored: brewery['isFavored'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "street": street,
      "city": city,
      "state": state,
      "country": country,
      "isFavored": true,
    };
  }
}
