import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dicoding_restaurant_app/utils/background_service.dart';
import 'package:dicoding_restaurant_app/utils/date_time_helper.dart';
import 'package:flutter/foundation.dart';

import 'package:dicoding_restaurant_app/data/preference/preference_helper.dart';

class PreferenceProvider extends ChangeNotifier {
  bool _isDailyReminderActive = false;

  PreferenceHelper preferenceHelper;

  PreferenceProvider({required this.preferenceHelper}) {
    _getDailyReminderPreference();
  }

  bool get isDailyReminderActive => _isDailyReminderActive;

  void _getDailyReminderPreference() async {
    _isDailyReminderActive = await preferenceHelper.isDailyReminderActive;
    notifyListeners();
  }

  void setDailyReminder(bool value) {
    preferenceHelper.setDailyReminder(value);
    _scheduleReminder(value);
    _getDailyReminderPreference();
  }

  void _scheduleReminder(bool value) async {
    if (value) {
      print("Scheduling Reminder Activated");
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
      );
    } else {
      print("Scheduling Reminder Deactivated");
      await AndroidAlarmManager.cancel(1);
    }
  }
}
