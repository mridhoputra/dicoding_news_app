import 'dart:io';
import 'package:dicoding_restaurant_app/common/navigation.dart';
import 'package:dicoding_restaurant_app/data/preference/preference_helper.dart';
import 'package:dicoding_restaurant_app/provider/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/utils/background_service.dart';
import 'package:dicoding_restaurant_app/utils/notification_helper.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:dicoding_restaurant_app/ui/home_page.dart';
import 'package:dicoding_restaurant_app/common/styles.dart';
import 'package:dicoding_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_search_page.dart';
import 'package:dicoding_restaurant_app/provider/database_provider.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_model.dart';
import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantsProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferenceProvider(
            preferenceHelper: PreferenceHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: poppinsTextTheme,
        ),
        navigatorKey: navigatorKey,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
              ),
          RestaurantSearchPage.routeName: (context) => const RestaurantSearchPage(),
        },
      ),
    );
  }
}
