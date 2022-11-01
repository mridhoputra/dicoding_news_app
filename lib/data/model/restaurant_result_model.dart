import 'package:dicoding_restaurant_app/data/model/restaurant_model.dart';

class RestaurantsResult {
  RestaurantsResult({
    this.error,
    this.message,
    this.count,
    this.restaurants,
  });

  bool? error;
  String? message;
  int? count;
  List<Restaurant>? restaurants;

  factory RestaurantsResult.fromJson(Map<String, dynamic> json) => RestaurantsResult(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants:
            List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants!.map((x) => x.toJson())),
      };
}
