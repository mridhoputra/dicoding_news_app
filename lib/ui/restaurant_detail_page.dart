import 'package:dicoding_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

import 'package:dicoding_restaurant_app/widgets/rating.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String idRestaurant;

  const RestaurantDetailPage({Key? key, required this.idRestaurant}) : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool _loading = false;
  String _restaurantDetailMessage = '';
  late RestaurantDetail _restaurantDetail;
  String _reviewName = '';
  String _reviewText = '';

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

  Future<dynamic> _fetchAddReview() async {
    try {
      setState(() {
        _loading = true;
      });
      final response =
          await ApiService().addReview(widget.idRestaurant, _reviewName, _reviewText);
      if (response.error) {
        Fluttertoast.showToast(
          msg: 'Ulasan gagal dikirim',
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Ulasan berhasil dikirim',
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          _reviewName = '';
          _reviewText = '';
        });
        _fetchDetailRestaurant();
      }
      setState(() {
        _loading = false;
      });
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
                  _buildSectionListReview(context),
                  const SizedBox(height: 16),
                  _buildSectionSendReview(context),
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

  Widget _buildSectionListReview(BuildContext context) {
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

  Widget _buildSectionSendReview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          thickness: 1.5,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        Text(
          'Pernah makan disini? Yuk kasih ulasan!',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        TextField(
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontSize: 14),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            hintText: 'Masukkan nama anda',
            labelText: 'Nama',
          ),
          onChanged: (value) {
            setState(() {
              _reviewName = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextField(
          maxLines: null,
          style: const TextStyle(fontSize: 14),
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            labelText: 'Ulasan',
            hintText: 'Masukkan ulasan anda',
          ),
          onChanged: (value) {
            setState(() {
              _reviewText = value;
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _showAlertDialog(context);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Kirim Ulasan',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(
          thickness: 1.5,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<dynamic> _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Kirim Ulasan'),
            content: const Text('Apakah anda yakin untuk mengirim ulasan ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_reviewName != '' && _reviewText != '') {
                    _fetchAddReview();
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Nama dan isi ulasan harus diisi',
                      toastLength: Toast.LENGTH_LONG,
                    );
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
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
