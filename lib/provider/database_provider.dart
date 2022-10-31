import 'package:dicoding_restaurant_app/data/db/database_helper.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];

  late DatabaseHelper _databaseHelper;

  List<Restaurant> get restaurants => _restaurants;

  DatabaseProvider() {
    _databaseHelper = DatabaseHelper();
    _getAllFavoriteRestaurants();
  }

  void _getAllFavoriteRestaurants() async {
    _restaurants = await _databaseHelper.getRestaurants();
    notifyListeners();
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    await _databaseHelper.insertRestaurant(restaurant);
    _getAllFavoriteRestaurants();
  }

  Future<void> getRestaurantById(int id) async {
    await _databaseHelper.getRestaurantById(id);
  }

  void deleteRestaurant(int id) async {
    await _databaseHelper.deleteRestaurant(id);
    _getAllFavoriteRestaurants();
  }
}
