import 'package:dicoding_restaurant_app/data/model/restaurant_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> json;

  String expectedId = 'rqdv5juczeskfw1e867';
  String expectedName = 'Melting Pot';
  String expectedDescription =
      'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.';
  String expectedCity = 'Medan';
  String expectedPictureId = '14';
  double expectedRating = 4.2;

  setUp(() {
    json = {
      "id": expectedId,
      "name": expectedName,
      "description": expectedDescription,
      "city": expectedCity,
      "pictureId": expectedPictureId,
      "rating": expectedRating,
    };
  });

  group('Restaurant Model Test', () {
    test('object has correct properties', () {
      final restaurant = Restaurant.fromJson(json);
      expect(restaurant.id, expectedId);
      expect(restaurant.name, expectedName);
      expect(restaurant.description, expectedDescription);
      expect(restaurant.city, expectedCity);
      expect(restaurant.pictureId, expectedPictureId);
      expect(restaurant.rating, expectedRating);
    });

    test('json has correct properties', () {
      final restaurant = Restaurant.fromJson(json);
      Map<String, dynamic> parsedRestaurant = restaurant.toJson();
      expect(parsedRestaurant["id"], expectedId);
      expect(parsedRestaurant["name"], expectedName);
      expect(parsedRestaurant["description"], expectedDescription);
      expect(parsedRestaurant["city"], expectedCity);
      expect(parsedRestaurant["pictureId"], expectedPictureId);
      expect(parsedRestaurant["rating"], expectedRating);
    });
  });
}
