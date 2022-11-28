import 'package:my_breweries/models/brewery.dart';

// CR: In case you would have used the Repository  design pattern, the encoding and decoding from JSON objects would ahve been contained, so this object would have been a DTO
class FavoredBreweriesList {
  List<Brewery> list = [];

  toJSONEncodable() {
    return list.map((item) {
      return item.toJson();
    }).toList();
  }
}
