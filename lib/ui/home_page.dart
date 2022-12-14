import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_favorite_page.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_search_page.dart';
import 'package:dicoding_restaurant_app/ui/settings_page.dart';
import 'package:dicoding_restaurant_app/utils/notification_helper.dart';

import 'package:dicoding_restaurant_app/ui/restaurant_list_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  static final now = DateTime.now();

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      label: 'Beranda',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search_rounded),
      label: 'Cari',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite_rounded),
      label: 'Favorit',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings_rounded),
      label: 'Pengaturan',
    ),
  ];

  final List<Widget> _listWidget = [
    const RestaurantListPage(),
    const RestaurantSearchPage(),
    const RestaurantFavoritePage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();

    _notificationHelper.configureSelectNotificationSubject(RestaurantDetailPage.routeName);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RestaurantsProvider>(context, listen: false)
          .fetchAllRestaurants(http.Client());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _listWidget[_bottomNavIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 10.0,
        selectedFontSize: 12.0,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
