import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_breweries/models/breweries_list.dart';
import 'package:my_breweries/models/brewery.dart';
import 'package:my_breweries/services/local_storage_service.dart';
import 'package:my_breweries/themes/color.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  double? deviceHeight, deviceWidth;

  bool initialized = false;
  LocalStorageService? storage;
  FavoredBreweriesList favoredBreweriesList = FavoredBreweriesList();
  String storageKey = 'favored_brewery_list';

  @override
  void initState() {
    super.initState();
    storage = GetIt.instance.get<LocalStorageService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    return FutureBuilder(
        future: storage!.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ));
          }
          if (!initialized) {
            var items = storage!.getItem(storageKey);
            if (items != null) {
              favoredBreweriesList.list = List<Brewery>.from(
                (favoredBreweriesList as List).map(
                  (item) => Brewery.fromJson(item),
                ),
              );
            }
            initialized = true;
          }
          return ListView.builder(
              itemCount: favoredBreweriesList.list.length,
              itemBuilder: (context, index) {
                return getCard(favoredBreweriesList.list[index]);
              });
        });
  }

  Widget getCard(item) {
    Brewery brewery = Brewery.fromJson(item);
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: () {},
          title: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: deviceWidth! * 0.75,
                          child: Text(
                            brewery.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Icon(
                        brewery.isFavored ? Icons.heart_broken : Icons.favorite,
                        color: Colors.pink,
                        size: 24.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Brewery Type: ${brewery.type},",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${brewery.street},",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${brewery.state},",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    brewery.country,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
