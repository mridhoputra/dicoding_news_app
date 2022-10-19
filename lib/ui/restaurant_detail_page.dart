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
  late RestaurantDetail _restaurant;
  bool _loading = false;

  static const _imageUrl = 'https://restaurant-api.dicoding.dev/images';

  Future<dynamic> _fetchDetailRestaurant() async {
    try {
      setState(() {
        _loading = true;
      });
      final response = await ApiService().getDetailRestaurant(widget.idRestaurant);
      if (response.error) {
        setState(() {
          _loading = false;
          _restaurantDetailMessage = 'Detail restoran tidak ditemukan';
        });
      } else {
        setState(() {
          _loading = false;
          _restaurant = response;
          _restaurantDetailMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _restaurantDetailMessage = '$e';
      });
    }
  }

  Widget _buildMenuItem(String menu) {
    return Text('- $menu');
  }

  Widget _buildDetailPage(BuildContext context) {
    Restaurant restaurantDetail = _restaurant.restaurant;
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: MediaQuery.of(context).orientation == Orientation.portrait
                    ? (MediaQuery.of(context).size.height * 0.32)
                    : (MediaQuery.of(context).size.height * 0.44),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: restaurantDetail.pictureId,
                    child: Image.network(
                      '$_imageUrl/medium/${restaurantDetail.pictureId}',
                      height: MediaQuery.of(context).orientation == Orientation.portrait
                          ? (MediaQuery.of(context).size.height * 0.32)
                          : (MediaQuery.of(context).size.height * 0.44),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                title: innerBoxIsScrolled ? const Text('Detail Restoran') : const Text(''),
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
                    restaurantDetail.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(height: 1, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurantDetail.city,
                    style: Theme.of(context).textTheme.caption!.copyWith(height: 1),
                  ),
                  const SizedBox(height: 4),
                  Rating(rating: restaurantDetail.rating),
                  const SizedBox(height: 16),
                  Text('Deskripsi Restoran:', style: Theme.of(context).textTheme.caption),
                  Text(restaurantDetail.description),
                  const SizedBox(height: 16),
                  Text('Menu yang tersedia', style: Theme.of(context).textTheme.caption),
                  const SizedBox(height: 4),
                  Text(
                    'Makanan:',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ...List.generate(restaurantDetail.menus.foods.length,
                      (index) => _buildMenuItem(restaurantDetail.menus.foods[index].name)),
                  const SizedBox(height: 8),
                  Text(
                    'Minuman:',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ...List.generate(restaurantDetail.menus.drinks.length,
                      (index) => _buildMenuItem(restaurantDetail.menus.drinks[index].name)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPage(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            title: const Text('Detail Restoran'),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 4),
                Text('Loading...')
              ],
            ),
          ),
        ],
      ),
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
    super.initState();
    _fetchDetailRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? _buildLoadingPage(context)
            : _restaurantDetailMessage == ''
                ? _buildDetailPage(context)
                : _buildErrorPage(context));
  }
}
