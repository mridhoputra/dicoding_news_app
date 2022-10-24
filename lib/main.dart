import 'package:dicoding_restaurant_app/common/styles.dart';
import 'package:dicoding_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:dicoding_restaurant_app/ui/home_page.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantsProvider>(
      create: (_) => RestaurantsProvider(apiService: ApiService()),
      child: MaterialApp(
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
          RestaurantSearchPage.routeName: (context) => const RestaurantSearchPage(),
        },
      ),
    );
  }
}
