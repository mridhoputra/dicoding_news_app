import 'package:dicoding_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_search_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dicoding_restaurant_app/data/api/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  String baseUrl = 'https://restaurant-api.dicoding.dev';
  String exampleIdRestaurant = 'rqdv5juczeskfw1e867';
  String exampleQuery = 'kafein';

  group('getAllRestaurants', () {
    test('returns RestaurantResults if the call http completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/list'))).thenAnswer((_) async =>
          http.Response('{"error": false, "message": "success", "count": 20}', 200));

      expect(await ApiService().getAllRestaurant(), isA<RestaurantsResult>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getAllRestaurant(), throwsException);
    });
  });

  group('getRestaurantDetail', () {
    test('returns RestaurantDetail if the call http completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/detail/$exampleIdRestaurant'))).thenAnswer(
          (_) async => http.Response(
              '{"error": false, "message": "success", "restaurant": {}}', 200));

      expect(await ApiService().getDetailRestaurant(exampleIdRestaurant),
          isA<RestaurantDetail>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/detail/$exampleIdRestaurant')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getDetailRestaurant(exampleIdRestaurant), throwsException);
    });
  });

  group('getRestaurantSearch', () {
    test('returns RestaurantSearch if the call http completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/search?q=$exampleQuery'))).thenAnswer((_) async =>
          http.Response('{"error": false, "founded": 1, "restaurant": []}', 200));

      expect(await ApiService().getSearchRestaurant(exampleQuery), isA<RestaurantSearch>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/search?q=$exampleQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getSearchRestaurant(exampleQuery), throwsException);
    });
  });
}
