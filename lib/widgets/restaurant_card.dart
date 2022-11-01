import 'package:dicoding_restaurant_app/common/navigation.dart';
import 'package:flutter/material.dart';

import 'package:dicoding_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  static const _imageUrl = 'https://restaurant-api.dicoding.dev/images';

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigation.intentWithData(RestaurantDetailPage.routeName, restaurant);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              Hero(
                tag: restaurant.pictureId,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      '$_imageUrl/medium/${restaurant.pictureId}',
                      width: double.infinity,
                      height: 200,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          restaurant.rating.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.circle,
                          color: Colors.grey,
                          size: 4,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          restaurant.city,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
