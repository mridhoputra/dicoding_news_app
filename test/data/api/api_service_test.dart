import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'api_service_test.mocks.dart';
import 'package:dicoding_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_search_model.dart';

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
      when(client.get(Uri.parse('$baseUrl/list'))).thenAnswer((_) async => http.Response(
          '{"error": false, "message": "success", "count": 20, "restaurants": []}', 200));

      expect(await ApiService().getAllRestaurant(client), isA<RestaurantsResult>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getAllRestaurant(client), throwsException);
    });
  });

  group('getRestaurantDetail', () {
    test('returns RestaurantDetail if the call http completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/detail/$exampleIdRestaurant'))).thenAnswer(
          (_) async => http.Response(
              '{ "error": false, "message": "success", "restaurant":{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"14","rating":4.2,"categories":[{"name":"Italia"},{"name":"Modern"}],"menus":{"foods":[{"name":"Paket rosemary"},{"name":"Toastie salmon"},{"name":"Bebek crepes"},{"name":"Salad lengkeng"}],"drinks":[{"name":"Es krim"},{"name":"Sirup"},{"name":"Jus apel"},{"name":"Jus jeruk"},{"name":"Coklat panas"},{"name":"Air"},{"name":"Es kopi"},{"name":"Jus alpukat"},{"name":"Jus mangga"},{"name":"Teh manis"},{"name":"Kopi espresso"},{"name":"Minuman soda"},{"name":"Jus tomat"}]},"customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"KELARRR","review":"ahahahahahahahaha","date":"4 November 2022"},{"name":"Arthur","review":"Lelah kah maniez?.","date":"4 November 2022"},{"name":"Test","review":"Test","date":"4 November 2022"},{"name":"Mikey","review":"Oii. . . Kiyomasa~","date":"4 November 2022"},{"name":"Berisik","review":"Berisi jangan nyepam anjir!!!","date":"4 November 2022"},{"name":"Orlando","review":"try good","date":"4 November 2022"},{"name":"dfsfsdf","review":"sdsdfd","date":"4 November 2022"},{"name":"jancok","review":"sdf","date":"4 November 2022"},{"name":"COba coba error wae c ok","review":"agafgafg","date":"4 November 2022"},{"name":"orlando","review":"coba coba sebm","date":"4 November 2022"},{"name":"stfu","review":"STFU!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!","date":"4 November 2022"},{"name":"Lorem","review":"Great Resto - 1667533795008","date":"4 November 2022"}]} }',
              200));

      expect(await ApiService().getDetailRestaurant(client, exampleIdRestaurant),
          isA<RestaurantDetail>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/detail/$exampleIdRestaurant')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
          ApiService().getDetailRestaurant(client, exampleIdRestaurant), throwsException);
    });
  });

  group('getRestaurantSearch', () {
    test('returns RestaurantSearch if the call http completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/search?q=$exampleQuery'))).thenAnswer((_) async =>
          http.Response('{ "error": false, "founded": 1, "restaurants": [] }', 200));

      expect(await ApiService().getSearchRestaurant(client, exampleQuery),
          isA<RestaurantSearch>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$baseUrl/search?q=$exampleQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getSearchRestaurant(client, exampleQuery), throwsException);
    });
  });
}
