import 'package:flutter/foundation.dart';

import 'package:dicoding_restaurant_app/data/db/database_helper.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_model.dart';

class DatabaseProvider extends ChangeNotifier {
  late DatabaseHelper _databaseHelper;

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  bool _isFavoriteRestaurant = false;
  bool get isFavoriteRestaurant => _isFavoriteRestaurant;

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
    checkFavoriteRestaurant(restaurant.id);
  }

  Future<Restaurant> getRestaurantById(String id) async {
    return await _databaseHelper.getRestaurantById(id);
  }

  void checkFavoriteRestaurant(String id) async {
    _isFavoriteRestaurant = await _databaseHelper.checkFavoriteRestaurant(id);
    notifyListeners();
  }

  void deleteRestaurant(String id) async {
    await _databaseHelper.deleteRestaurant(id);
    _getAllFavoriteRestaurants();
    checkFavoriteRestaurant(id);
  }
}
