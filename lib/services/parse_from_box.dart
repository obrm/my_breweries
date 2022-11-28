import 'package:hive/hive.dart';
import 'package:my_breweries/models/brewery.dart';

// CR: All handleing of Box should be used inside a service wrapping Hive.
// CR: Therefor the dependency would be in an internal repository, so only one location (as much as we can would be dependent on Hive)
List<Brewery> parseFromBox(Box box) {
  return List<Brewery>.from(
    (box.values.toList()).map(
      (item) => Brewery.fromJson(item),
    ),
  );
}
