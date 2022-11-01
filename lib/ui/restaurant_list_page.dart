import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_restaurant_app/widgets/restaurant_card.dart';
import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  String formatGreeting() {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    if (currentHour >= 5 && currentHour < 11) {
      return 'Selamat Pagi,';
    } else if (currentHour >= 11 && currentHour < 15) {
      return 'Selamat Siang,';
    } else if (currentHour >= 15 && currentHour < 18) {
      return 'Selamat Sore,';
    } else if (currentHour >= 18 || currentHour < 5) {
      return 'Selamat Malam,';
    } else {
      return 'Selamat Datang,';
    }
  }

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
            formatGreeting(),
            style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            'Mau makan dimana hari ini?',
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
