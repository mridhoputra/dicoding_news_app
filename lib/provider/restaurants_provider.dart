import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dicoding_restaurant_app/utils/result_state.dart';
import 'package:dicoding_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_search_model.dart';

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsProvider({required this.apiService});

  RestaurantsResult _restaurantsResult = RestaurantsResult();
  RestaurantSearch _restaurantSearch = RestaurantSearch();
  RestaurantDetail _restaurantDetail = RestaurantDetail();

  ResultState _restaurantResultState = ResultState.initial;
  ResultState _restaurantSearchState = ResultState.initial;
  ResultState _restaurantDetailState = ResultState.initial;
  ResultState _restaurantAddReviewState = ResultState.initial;

  String _restaurantResultMessage = '';
  String _restaurantSearchMessage = '';
  String _restaurantDetailMessage = '';
  String _restaurantAddReviewMessage = '';

  ResultState get restaurantResultState => _restaurantResultState;
  ResultState get restaurantSearchState => _restaurantSearchState;
  ResultState get restaurantDetailState => _restaurantDetailState;
  ResultState get restaurantAddReviewState => _restaurantAddReviewState;

  String get restaurantResultMessage => _restaurantResultMessage;
  String get restaurantSearchMessage => _restaurantSearchMessage;
  String get restaurantDetailMessage => _restaurantDetailMessage;
  String get restaurantAddReviewMessage => _restaurantAddReviewMessage;

  RestaurantsResult? get restaurantResult => _restaurantsResult;
  RestaurantSearch? get restaurantSearch => _restaurantSearch;
  RestaurantDetail? get restaurantDetail => _restaurantDetail;

  Future<dynamic> fetchAllRestaurants(http.Client client) async {
    try {
      _restaurantResultState = ResultState.loading;
      notifyListeners();
      final response = await apiService.getAllRestaurant(client);
      if (response.restaurants!.isEmpty) {
        _restaurantResultState = ResultState.noData;
        notifyListeners();
        return _restaurantResultMessage = 'Tidak ada restoran yang bisa ditampilkan';
      } else {
        _restaurantResultState = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = response;
      }
    } catch (e) {
      _restaurantResultState = ResultState.error;
      notifyListeners();
      return _restaurantResultMessage = '$e';
    }
  }

  Future<dynamic> fetchRestaurantByName(http.Client client, String query) async {
    try {
      _restaurantSearchState = ResultState.loading;
      notifyListeners();
      final response = await apiService.getSearchRestaurant(client, query);
      if (response.error!) {
        _restaurantSearchState = ResultState.error;
        notifyListeners();
        if (response.message!.isNotEmpty) {
          return _restaurantSearchMessage = response.message!;
        } else {
          return _restaurantSearchMessage = 'Maaf, terjadi kesalahan';
        }
      } else {
        _restaurantSearchState = ResultState.hasData;
        notifyListeners();
        return _restaurantSearch = response;
      }
    } catch (e) {
      _restaurantSearchState = ResultState.error;
      notifyListeners();
      return _restaurantResultMessage = '$e';
    }
  }

  Future<dynamic> fetchDetailRestaurant(http.Client client, String idRestaurant) async {
    try {
      _restaurantDetailState = ResultState.loading;
      notifyListeners();
      final response = await apiService.getDetailRestaurant(client, idRestaurant);
      if (response.error!) {
        _restaurantDetailState = ResultState.error;
        notifyListeners();
        if (response.message!.isNotEmpty) {
          return _restaurantDetailMessage = response.message!;
        } else {
          return _restaurantDetailMessage = 'Maaf, terjadi kesalahan';
        }
      } else {
        _restaurantDetailState = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = response;
      }
    } catch (e) {
      _restaurantDetailState = ResultState.error;
      notifyListeners();
      return _restaurantDetailMessage = '$e';
    }
  }

  Future<String> fetchAddReview(String idRestaurant, String name, String review) async {
    try {
      _restaurantAddReviewState = ResultState.loading;
      notifyListeners();
      final response = await apiService.addReview(idRestaurant, name, review);
      if (response.error) {
        _restaurantAddReviewState = ResultState.error;
        notifyListeners();
        if (response.message.isNotEmpty) {
          return _restaurantAddReviewMessage = response.message;
        } else {
          return _restaurantAddReviewMessage = 'Ulasan gagal dikirim';
        }
      } else {
        _restaurantAddReviewState = ResultState.hasData;
        notifyListeners();
        return _restaurantAddReviewMessage = 'Ulasan berhasil dikirim';
      }
    } catch (e) {
      _restaurantAddReviewState = ResultState.error;
      notifyListeners();
      return _restaurantDetailMessage = '$e';
    }
  }
}
