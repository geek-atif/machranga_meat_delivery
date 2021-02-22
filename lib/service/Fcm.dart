import 'dart:convert';

import 'package:Machranga/util/sharedpreferences_constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fcm {
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/app_notification');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      showNotification(data, flutterLocalNotificationsPlugin);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  static void showNotification(message,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    final data = jsonDecode(message['data']);
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    flutterLocalNotificationsPlugin.show(
        0, data['title'], data['message'], platform);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences.getInstance().then(
      (prefs) {
        int count;
        count = prefs.getInt(SharedpreferencesConstant.notificationCount);
        print('before count : ${count}');
        if (count == null)
          prefs.setInt(SharedpreferencesConstant.notificationCount, 1);
        else
          prefs.setInt(SharedpreferencesConstant.notificationCount, count + 1);
        count = prefs.getInt(SharedpreferencesConstant.notificationCount);
        print(
            'after count : ${count}  ${prefs.getInt(SharedpreferencesConstant.userId)}');
      },
    );
  }
}
