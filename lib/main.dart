import 'package:dicoding_restaurant_app/common/styles.dart';
import 'package:dicoding_restaurant_app/ui/home_page.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant_app/ui/search_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: poppinsTextTheme,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
              idRestaurant: ModalRoute.of(context)?.settings.arguments as String,
            ),
        SearchPage.routeName: (context) => const SearchPage(),
      },
    );
  }
}
