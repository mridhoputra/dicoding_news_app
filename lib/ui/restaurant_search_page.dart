import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:dicoding_restaurant_app/utils/result_state.dart';
import 'package:dicoding_restaurant_app/widgets/restaurant_card.dart';
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
            return RestaurantCard(restaurant: restaurantSearch.restaurants![index]);
          },
        ),
      );
    }
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
      body: Container(
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
                      .fetchRestaurantByName(http.Client(), _query);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildSearchResult(context),
          ],
        ),
      ),
    );
  }
}
