import 'package:flutter/material.dart';

import 'package:dicoding_restaurant_app/ui/restaurant_list_page.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search_page';

  static final now = DateTime.now();

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Column(
                    children: [
                      Text(
                        'Cari Restoran',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                ],
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
            ],
          ),
        ),
      ),
    );
  }
}
