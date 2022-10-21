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
  late RestaurantDetail _restaurantDetail;
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
          _restaurantDetail = response;
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

  Widget _buildDetailPage(BuildContext context) {
    Restaurant restaurantDetail = _restaurantDetail.restaurant;
    double imageHeight = MediaQuery.of(context).orientation == Orientation.portrait
        ? (MediaQuery.of(context).size.height * 0.32)
        : (MediaQuery.of(context).size.height * 0.44);
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: imageHeight,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: restaurantDetail.pictureId,
                    child: Image.network(
                      '$_imageUrl/medium/${restaurantDetail.pictureId}',
                      fit: BoxFit.cover,
                      height: imageHeight,
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
                  const SizedBox(height: 6),
                  Text(
                    '${restaurantDetail.address}, ${restaurantDetail.city}',
                    style: Theme.of(context).textTheme.caption!.copyWith(height: 1),
                  ),
                  const SizedBox(height: 8),
                  Rating(
                    rating: restaurantDetail.rating,
                    reviewCount: restaurantDetail.customerReviews!.isEmpty
                        ? 0
                        : restaurantDetail.customerReviews!.length,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: restaurantDetail.categories.map((category) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: const BoxDecoration(
                            color: Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.all(Radius.circular(24))),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                              color: Color(0xFF8B8B8B), fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
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
                      (index) => Text('- ${restaurantDetail.menus.foods[index].name}')),
                  const SizedBox(height: 8),
                  Text(
                    'Minuman:',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ...List.generate(
                    restaurantDetail.menus.drinks.length,
                    (index) => Text('- ${restaurantDetail.menus.drinks[index].name}'),
                  ),
                  const SizedBox(height: 16),
                  _buildReviewList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPage(BuildContext context) {
    double imageHeight = MediaQuery.of(context).orientation == Orientation.portrait
        ? (MediaQuery.of(context).size.height * 0.32)
        : (MediaQuery.of(context).size.height * 0.44);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: imageHeight,
                color: Colors.grey,
              ),
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.white,
                    )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
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

  Widget _buildReviewList(BuildContext context) {
    if (_restaurantDetail.restaurant.customerReviews!.isNotEmpty) {
      var customerReviews = _restaurantDetail.restaurant.customerReviews!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Ulasan Pengguna', style: Theme.of(context).textTheme.caption),
          const SizedBox(height: 8),
          ...List.generate(customerReviews.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        customerReviews[index].name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customerReviews[index].name),
                        const SizedBox(height: 2),
                        Text(
                          customerReviews[index].date,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Ulasan: ${customerReviews[index].review}'),
                const SizedBox(height: 8),
              ],
            );
          })
        ],
      );
    } else {
      return Container();
    }
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
