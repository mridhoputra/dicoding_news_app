import 'package:dicoding_restaurant_app/provider/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_restaurant_app/widgets/restaurant_card.dart';

class RestaurantFavoritePage extends StatelessWidget {
  const RestaurantFavoritePage({Key? key}) : super(key: key);

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, databaseProvider, _) {
        if (databaseProvider.restaurants.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Restoran favorit masih kosong!',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Suka dengan restoran yang kamu lihat? Tap ikon hati untuk simpan restoran favoritmu!',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              )
            ],
          );
        } else {
          return ListView.builder(
            itemCount: databaseProvider.restaurants.length,
            itemBuilder: (context, index) {
              return RestaurantCard(restaurant: databaseProvider.restaurants[index]);
            },
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
