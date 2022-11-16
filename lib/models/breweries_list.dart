import 'package:my_breweries/models/brewery.dart';

class BreweriesList {
  List<Brewery> list = [];

  toJSONEncodable() {
    return list.map((item) => item.toMap()).toList();
  }

  addItemToList(item) {
    list.add(item);
  }

  removeItemFromList(String id) {
    return list.removeWhere((item) => item.id == id);
  }
}
