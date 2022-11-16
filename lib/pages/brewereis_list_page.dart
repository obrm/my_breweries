import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_breweries/models/breweries_list.dart';
import 'package:my_breweries/models/brewery.dart';
import 'package:my_breweries/themes/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreweriesListPage extends StatefulWidget {
  const BreweriesListPage({super.key});

  @override
  BreweriesListPageState createState() => BreweriesListPageState();
}

class BreweriesListPageState extends State<BreweriesListPage> {
  List breweriesFromAPI = [];
  bool isLoading = false;
  double? deviceHeight, deviceWidth;

  String stringListName = 'favored_breweries';
  List<String>? favoredBreweriesList;

  @override
  void initState() {
    super.initState();
    _loadFavoredBreweries();
    fetchBreweries();
  }

  Future<void> _loadFavoredBreweries() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoredBreweriesList = ((prefs.getStringList(stringListName)) ?? []);
    });
  }

  Future<void> _addBreweryToFavored(Brewery brewery) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoredBreweriesList!.add(brewery.toString());
      prefs.setStringList(stringListName, favoredBreweriesList!);
    });
  }

  Future<void> _removeBreweryFromFavored(Brewery brewery) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoredBreweriesList!
          .removeWhere((item) => Brewery.fromJson(item).id == brewery.id);
      prefs.setStringList(stringListName, favoredBreweriesList!);
    });
  }

  bool _checkIfBreweryIsFavored(Brewery brewery) {
    return favoredBreweriesList!.firstWhere(
            (e) => Brewery.fromJson(e).id == brewery.id,
            orElse: () => '') !=
        '';
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
        breweriesFromAPI = items;
        isLoading = false;
      });
    } else {
      breweriesFromAPI = [];
      isLoading = false;
    }
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
    if (breweriesFromAPI.contains(null) || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: breweriesFromAPI.length,
        itemBuilder: (context, index) {
          return getBreweryCard(breweriesFromAPI[index]);
        });
  }

  Widget getBreweryCard(item) {
    Brewery brewery = Brewery.fromMap(item);
    bool isFavored = _checkIfBreweryIsFavored(brewery);
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: () {
            if (isFavored) {
              _removeBreweryFromFavored(brewery);
              setState(() {
                isFavored = false;
              });
            } else {
              _addBreweryToFavored(brewery);
              setState(() {
                isFavored = true;
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
                          )),
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
