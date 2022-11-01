import 'dart:io';

import 'package:dicoding_restaurant_app/provider/preference_provider.dart';
import 'package:dicoding_restaurant_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Pengaturan',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.1),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pengingat Harian'),
                      Text(
                        'Setiap jam 11.00 siang',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  Consumer<PreferenceProvider>(
                    builder: (context, preferenceProvider, _) {
                      return Switch.adaptive(
                        value: preferenceProvider.isDailyReminderActive,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            customDialog(context);
                          } else {
                            preferenceProvider.setDailyReminder(value);
                            if (value) {
                              Fluttertoast.showToast(
                                msg: 'Pengingat Harian diaktifkan',
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Pengingat Harian dimatikan',
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
