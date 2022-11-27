import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:my_breweries/models/favored_breweries_list.dart';
import 'package:my_breweries/models/brewery.dart';
import 'package:my_breweries/services/parse_from_box.dart';
import 'package:my_breweries/themes/color.dart';

class BreweriesListPage extends StatefulWidget {
  const BreweriesListPage({super.key});

  @override
  BreweriesListPageState createState() => BreweriesListPageState();
}

class BreweriesListPageState extends State<BreweriesListPage> {
  List breweries = [];
  bool isLoading = false;
  double? deviceWidth;

  Box? box;
  FavoredBreweriesList favoredBreweriesList = FavoredBreweriesList();
  String boxKey = 'favored_breweries_list';

  @override
  void initState() {
    super.initState();
    fetchBreweries();
  }

  fetchBreweries() async {
    setState(() {
      isLoading = true;
    });
    Uri httpsUri = Uri(
        scheme: 'https',
        host: 'api.openbrewerydb.org',
        path: '/breweries',
        fragment: 'numbers'); // "https://api.openbrewerydb.org/breweries"
    var response = await http.get(httpsUri);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        breweries = items;
        isLoading = false;
      });
    } else {
      breweries = [];
      isLoading = false;
    }
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
          if (breweries.contains(null) || isLoading || snapshot.data == null) {
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
              itemCount: breweries.length,
              itemBuilder: (context, index) {
                return getCard(breweries[index]);
              });
        });
  }

  Widget getCard(item) {
    Brewery brewery = Brewery.fromJson(item);
    bool isFavored = favoredBreweriesList.list
            .indexWhere((element) => element.id == brewery.id) !=
        -1;
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: () {
            if (isFavored) {
              int breweryIndex = favoredBreweriesList.list
                  .indexWhere((element) => element.id == brewery.id);
              box!.deleteAt(breweryIndex);
              favoredBreweriesList.list = parseFromBox(box!);
              setState(() {
                isFavored = false;
              });
            } else {
              box!.add(brewery.toJson());
              setState(() {
                favoredBreweriesList.list = parseFromBox(box!);
              });
            }
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
                        ),
                      ),
                      Icon(
                        isFavored ? Icons.heart_broken : Icons.favorite,
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
                    ],
                  ),
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
