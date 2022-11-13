class Brewery {
  final String id;
  final String name;
  final String type;
  final String street;
  final String city;
  final String state;
  final String country;
  final bool? isLiked;

  const Brewery({
    required this.id,
    required this.name,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.isLiked,
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
      isLiked: brewery['isLiked'],
    );
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
      "isLiked": isLiked,
    };
  }
}
