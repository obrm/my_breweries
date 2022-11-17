import 'package:hive/hive.dart';
import 'package:my_breweries/models/brewery.dart';

List<Brewery> parseFromBox(Box box) {
  return List<Brewery>.from(
    (box.values.toList()).map(
      (item) => Brewery.fromJson(item),
    ),
  );
}
