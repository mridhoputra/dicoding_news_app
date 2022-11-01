import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:dicoding_restaurant_app/common/navigation.dart';

customDialog(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Coming Soon!'),
            content: const Text('This feature will be coming soon!'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigation.goBack();
                },
                child: const Text('Ok'),
              )
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Coming Soon!'),
            content: const Text('This feature will be coming soon!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigation.goBack();
                },
                child: const Text('Ok'),
              )
            ],
          );
        });
  }
}
