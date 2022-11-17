import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_breweries/pages/favorites_page.dart';
import 'package:my_breweries/pages/home_page.dart';
import 'package:my_breweries/services/build_material_color.dart';
import 'package:my_breweries/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerLocalStorageService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Breweries',
      theme: ThemeData(
        primarySwatch: buildMaterialColor(
          const Color(0xFF0008C1),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(
          230,
          203,
          168,
          1.0,
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomePage(),
        'favorites': (context) => const FavoritesPage(),
      },
    );
  }
}

void registerLocalStorageService() {
  GetIt.instance.registerSingleton<LocalStorageService>(
    LocalStorageService(),
  );
}
