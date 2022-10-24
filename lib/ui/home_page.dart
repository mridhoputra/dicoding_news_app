import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:flutter/material.dart';

import 'package:dicoding_restaurant_app/ui/restaurant_list_page.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_search_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  static final now = DateTime.now();

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RestaurantsProvider>(context, listen: false).fetchAllRestaurants();
    });
  }

  String formatGreeting() {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    if (currentHour >= 5 && currentHour < 11) {
      return 'Selamat Pagi,';
    } else if (currentHour >= 11 && currentHour < 15) {
      return 'Selamat Siang,';
    } else if (currentHour >= 15 && currentHour < 18) {
      return 'Selamat Sore,';
    } else if (currentHour >= 18 || currentHour < 5) {
      return 'Selamat Malam,';
    } else {
      return 'Selamat Datang,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatGreeting(),
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                  InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search, size: 28),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RestaurantSearchPage.routeName);
                    },
                  )
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Mau makan dimana hari ini?',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: RestaurantListPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
