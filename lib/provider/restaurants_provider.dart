import 'package:dicoding_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsProvider({required this.apiService}) {
    _fetchAllRestaurants();
  }

  late RestaurantsResult _restaurantsResult;

  late ResultState _restaurantsResultState;

  String _restaurantResultMessage = '';

  String get restaurantResultMessage => _restaurantResultMessage;

  ResultState get restaurantsResultState => _restaurantsResultState;

  RestaurantsResult? get restaurantResult => _restaurantsResult;

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _restaurantsResultState = ResultState.loading;
      notifyListeners();
      final response = await apiService.getAllRestaurant();
      if (response.restaurants.isEmpty) {
        _restaurantsResultState = ResultState.noData;
        notifyListeners();
        return _restaurantResultMessage = 'Tidak ada restoran yang bisa ditampilkan';
      } else {
        _restaurantsResultState = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = response;
      }
    } catch (e) {
      _restaurantsResultState = ResultState.error;
      notifyListeners();
      return _restaurantResultMessage = '$e';
    }
  }
}
