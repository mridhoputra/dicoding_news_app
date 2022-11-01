import 'package:dicoding_restaurant_app/data/model/restaurant_model.dart';

class RestaurantSearch {
  RestaurantSearch({
    this.error,
    this.founded,
    this.restaurants,
    this.message,
  });

  bool? error;
  int? founded;
  List<Restaurant>? restaurants;
  String? message;

  factory RestaurantSearch.fromJson(Map<String, dynamic> json) => RestaurantSearch(
        error: json["error"],
        founded: json["founded"],
        restaurants:
            List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants!.map((x) => x.toJson())),
        "message": message,
      };
}
