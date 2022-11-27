import 'package:my_breweries/models/brewery.dart';

class FavoredBreweriesList {
  List<Brewery> list = [];

  toJSONEncodable() {
    return list.map((item) {
      return item.toJson();
    }).toList();
  }
}
