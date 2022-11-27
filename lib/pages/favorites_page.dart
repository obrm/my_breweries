import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_breweries/models/favored_breweries_list.dart';
import 'package:my_breweries/models/brewery.dart';
import 'package:my_breweries/services/parse_from_box.dart';
import 'package:my_breweries/themes/color.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  double? deviceWidth;

  Box? box;
  FavoredBreweriesList favoredBreweriesList = FavoredBreweriesList();
  String boxKey = 'favored_breweries_list';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    return FutureBuilder(
        future: Hive.openBox(boxKey),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ));
          }
          if (snapshot.hasData) {
            box = snapshot.data;
            favoredBreweriesList.list = parseFromBox(box!);
          }
          return ListView.builder(
              itemCount: favoredBreweriesList.list.length,
              itemBuilder: (context, index) {
                return getCard(favoredBreweriesList.list[index], index);
              });
        });
  }

  Widget getCard(Brewery brewery, int index) {
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: () {
            setState(() {
              box!.deleteAt(index);
              favoredBreweriesList.list = parseFromBox(box!);
            });
          },
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
                      const Icon(
                        Icons.heart_broken,
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
