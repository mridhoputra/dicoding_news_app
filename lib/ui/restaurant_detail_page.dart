import 'package:dicoding_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

import 'package:dicoding_restaurant_app/widgets/rating.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String idRestaurant;

  const RestaurantDetailPage({Key? key, required this.idRestaurant}) : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  String _restaurantDetailMessage = '';
  late Future<RestaurantDetail> _restaurant;

  static const _imageUrl = 'https://restaurant-api.dicoding.dev/images';

  Widget _buildMenuItem(String menu) {
    return Text('- $menu');
  }

  Widget _buildDetailPage(BuildContext context) {
    return FutureBuilder<RestaurantDetail>(
      future: _restaurant,
      builder: (context, AsyncSnapshot<RestaurantDetail> snapshot) {
        var state = snapshot.connectionState;
        if (state != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            Restaurant restaurant = snapshot.data!.restaurant;
            return NestedScrollView(
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
                              '$_imageUrl/medium/${restaurant.pictureId}',
                              height:
                                  MediaQuery.of(context).orientation == Orientation.portrait
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
                            style: Theme.of(context).textTheme.caption!.copyWith(height: 1),
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
                              (index) =>
                                  _buildMenuItem(restaurant.menus.drinks[index].name)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('OK');
          } else {
            return Text('OK');
          }
        }
      },
    );
  }

  Widget _buildErrorPage(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(title: const Text('Detail Restoran')),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Maaf, terjadi kesalahan.'),
                const SizedBox(height: 8),
                Text(_restaurantDetailMessage),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      _restaurant = ApiService().getDetailRestaurant(widget.idRestaurant);
      setState(() {
        _restaurantDetailMessage = '';
      });
    } catch (e) {
      setState(() {
        _restaurantDetailMessage = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _restaurantDetailMessage == ''
            ? _buildDetailPage(context)
            : _buildErrorPage(context));
  }
}
