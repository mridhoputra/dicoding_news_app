import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_search_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_detail_model.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantsResult> getAllRestaurant() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/list'));
      if (response.statusCode == 200) {
        return RestaurantsResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat list restoran');
      }
    } on TimeoutException {
      throw Exception('Server tidak merespon, silahkan coba lagi nanti');
    } on SocketException {
      throw Exception('Gagal memuat list restoran, silahkan periksa koneksi internet anda');
    } on Error {
      throw Exception('Silahkan coba lagi nanti');
    }
  }

  Future<RestaurantDetail> getDetailRestaurant(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
      if (response.statusCode == 200) {
        return RestaurantDetail.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat detail restoran');
      }
    } on TimeoutException {
      throw Exception('Server tidak merespon, silahkan coba lagi nanti');
    } on SocketException {
      throw Exception(
          'Gagal memuat detail restoran, silahkan periksa koneksi internet anda');
    } on Error {
      throw Exception('Silahkan coba lagi nanti');
    }
  }

  Future<RestaurantSearch> getSearchRestaurant(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
      if (response.statusCode == 200) {
        return RestaurantSearch.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat hasil pencarian restoran');
      }
    } on TimeoutException {
      throw Exception('Server tidak merespon, silahkan coba lagi nanti');
    } on SocketException {
      throw Exception('Gagal memuat list restoran, silahkan periksa koneksi internet anda');
    } on Error {
      throw Exception('Silahkan coba lagi nanti');
    }
  }
}
