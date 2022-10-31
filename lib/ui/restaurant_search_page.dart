import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant_app/provider/restaurants_provider.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_search_model.dart';

class RestaurantSearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  static final now = DateTime.now();

  const RestaurantSearchPage({Key? key}) : super(key: key);

  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  String _query = '';
  static const _imageUrl = 'https://restaurant-api.dicoding.dev/images';

  Widget _buildList(BuildContext context, RestaurantSearch restaurantSearch) {
    if (restaurantSearch.restaurants!.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('Hasil restoran tidak ditemukan'),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: restaurantSearch.restaurants!.length,
          itemBuilder: (context, index) {
            return _buildItem(context, restaurantSearch.restaurants![index]);
          },
        ),
      );
    }
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

  Widget _buildSearchResult(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (context, state, _) {
        if (state.restaurantSearchState == ResultState.initial) {
          return Container();
        } else if (state.restaurantSearchState == ResultState.loading) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Loading'),
              ],
            ),
          );
        } else if (state.restaurantSearchState == ResultState.hasData) {
          return _buildList(context, state.restaurantSearch!);
        } else {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Maaf, terjadi kesalahan,'),
                const SizedBox(height: 8),
                Text(state.restaurantSearchMessage),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pencarian',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(width: 32),
              const SizedBox(height: 8),
              TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  fillColor: const Color(0xFFEDECEB),
                  hintText: 'Cari nama restoran',
                  prefixIcon: const Icon(Icons.search, size: 24),
                  hintStyle: const TextStyle(color: Color(0xFF878787)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                onEditingComplete: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_query != '') {
                    Provider.of<RestaurantsProvider>(context, listen: false)
                        .fetchRestaurantByName(_query);
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildSearchResult(context),
            ],
          ),
        ),
      ),
    );
  }
}
