class Brewery {
  final String id;
  final String name;
  final String type;
  final String street;
  final String city;
  final String state;
  final String country;

  const Brewery({
    required this.id,
    required this.name,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
  });

  factory Brewery.fromObject(Map<String, dynamic> object) {
    return Brewery(
      id: object['id'],
      name: object['name'],
      type: object['brewery_type'],
      street: object['street'],
      city: object['city'],
      state: object['state'],
      country: object['country'],
    );
  }
}
