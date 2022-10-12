import 'package:flutter/material.dart';

import 'package:dicoding_restaurant_app/widgets/rating.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_list_model.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant})
      : super(key: key);

  Widget _buildMenuItem(String menu) {
    return Text('- $menu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  pinned: true,
                  expandedHeight:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? (MediaQuery.of(context).size.height * 0.32)
                          : (MediaQuery.of(context).size.height * 0.44),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: restaurant.pictureId,
                      child: Image.network(
                        restaurant.pictureId,
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? (MediaQuery.of(context).size.height * 0.32)
                            : (MediaQuery.of(context).size.height * 0.44),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  title: innerBoxIsScrolled
                      ? const Text('Detail Restoran')
                      : const Text(''),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(height: 1, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.city,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(height: 1),
                    ),
                    const SizedBox(height: 4),
                    Rating(rating: restaurant.rating),
                    const SizedBox(height: 16),
                    Text('Deskripsi Restoran:',
                        style: Theme.of(context).textTheme.caption),
                    Text(restaurant.description),
                    const SizedBox(height: 16),
                    Text('Menu yang tersedia',
                        style: Theme.of(context).textTheme.caption),
                    const SizedBox(height: 4),
                    Text(
                      'Makanan:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    ...List.generate(
                        restaurant.menus.foods.length,
                        (index) =>
                            _buildMenuItem(restaurant.menus.foods[index].name)),
                    const SizedBox(height: 8),
                    Text(
                      'Minuman:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    ...List.generate(
                        restaurant.menus.drinks.length,
                        (index) => _buildMenuItem(
                            restaurant.menus.drinks[index].name)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
