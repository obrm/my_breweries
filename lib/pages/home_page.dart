import 'package:flutter/material.dart';
import 'package:my_breweries/pages/brewereis_list_page.dart';
import 'package:my_breweries/pages/favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? deviceHeight, deviceWidth;

  int currentPage = 0;
  final List<Widget> pages = [
    const BreweriesListPage(),
    const FavoritesPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

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
      bottomNavigationBar: _bottomNavigationBar(),
      body: pages[currentPage],
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(
        230,
        203,
        168,
        1.0,
      ),
      selectedItemColor: const Color.fromRGBO(88, 66, 55, 1.0),
      currentIndex: currentPage,
      onTap: (index) {
        setState(() {
          currentPage = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Breweries List',
          icon: Icon(
            Icons.list_alt,
            color: Color.fromRGBO(88, 66, 55, 1.0),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Favorite Breweries',
          icon: Icon(
            Icons.favorite,
            color: Color.fromRGBO(88, 66, 55, 1.0),
          ),
        ),
      ],
    );
  }
}
