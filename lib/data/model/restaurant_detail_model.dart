import 'package:dicoding_restaurant_app/data/model/restaurant_model.dart';

class RestaurantDetail {
  RestaurantDetail({
    this.error,
    this.message,
    this.restaurant,
  });

  bool? error;
  String? message;
  Restaurant? restaurant;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) => RestaurantDetail(
        error: json["error"],
        message: json["message"],
        restaurant: Restaurant.fromJsonDetail(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant!.toJsonDetail(),
      };
}
