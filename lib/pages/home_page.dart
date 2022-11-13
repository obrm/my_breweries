import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_breweries/models/brewery.dart';
import 'package:my_breweries/themes/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List breweries = [];
  bool isLoading = false;
  double? deviceHeight;

  @override
  void initState() {
    super.initState();
    fetchBreweries();
  }

  fetchBreweries() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://api.openbrewerydb.org/breweries";
    var response = await http.get(url);
    // print(response.body);
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
    deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: deviceHeight! * 0.25,
        title: const Text(
          "My Breweries",
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.w800,
            color: Color.fromRGBO(
              253,
              240,
              224,
              1.0,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/brewery.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (breweries.contains(null) || breweries.length < 0 || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: breweries.length,
        itemBuilder: (context, index) {
          return getCard(breweries[index]);
        });
  }

  Widget getCard(item) {
    Brewery brewery = Brewery.fromObject(item);
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 140,
                      child: Text(
                        brewery.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
