import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:dicoding_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  static const _imageUrl = 'https://restaurant-api.dicoding.dev/images';

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (context, state, _) {
        if (state.restaurantResultState == ResultState.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 4),
                Text('Loading...')
              ],
            ),
          );
        } else if (state.restaurantResultState == ResultState.hasData) {
          RestaurantsResult restaurantsResult = state.restaurantResult!;
          return ListView.builder(
            itemCount: restaurantsResult.restaurants!.length,
            itemBuilder: (context, index) {
              return _buildItem(context, restaurantsResult.restaurants![index]);
            },
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text("Maaf, terjadi kesalahan."),
              const SizedBox(height: 8),
              Text(state.restaurantResultMessage),
            ],
          );
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, RestaurantDetailPage.routeName,
              arguments: restaurant.id);
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

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}
