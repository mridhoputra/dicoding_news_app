import 'package:dicoding_restaurant_app/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';

class RestaurantFavoritePage extends StatelessWidget {
  const RestaurantFavoritePage({Key? key}) : super(key: key);

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
              return RestaurantCard(restaurant: restaurantsResult.restaurants![index]);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Restoran Favorit',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            'Restoran pilihanmu dalam satu halaman',
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildList(context),
          ),
        ],
      ),
    );
  }
}
