import 'dart:convert';
import '../screens/bottom_navigation_screen.dart';
import '../screens/welcome_screen.dart';
import '../widgets/slide_route.dart';
import '../service/Fcm.dart';
import '../util/constant.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../util/images.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLogin = false;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  _startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationToWelcomeScreen);
  }

  void navigationToWelcomeScreen() {
    final prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      _isLogin = value.getBool(SharedpreferencesConstant.isLogin);

      if (_isLogin != null) {
        if (_isLogin) {
          Navigator.pushReplacement(
              context, SlideLeftRoute(page: MyBottomNavScreen()));
        } else {
          Navigator.pushReplacement(
              context, SlideLeftRoute(page: WelcomeScreen()));
        }
      } else
        Navigator.pushReplacement(
            context, SlideLeftRoute(page: WelcomeScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    var android = new AndroidInitializationSettings('mipmap/app_notification');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
      //print("Splash configure");
      onLaunch: (Map<String, dynamic> msg) {
        //showNotification(msg);
        print("Splash onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        //showNotification(msg);
        print("Splash onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        showNotification(msg);
        print("Splash onMessage called ${(msg)}");
      },

      onBackgroundMessage: Fcm.myBackgroundMessageHandler,
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, alert: true, badge: true, provisional: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });

    _startTime();
  }

  showNotification(Map<String, dynamic> message) async {
    final data = jsonDecode(message['data']['data']);
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, data['title'], data['message'], platform);
    SharedPreferences.getInstance().then(
      (prefs) {
        int count;
        count = prefs.getInt(SharedpreferencesConstant.notificationCount);
        print('beofrecount : ${count}');
        if (count == null)
          prefs.setInt(SharedpreferencesConstant.notificationCount, 1);
        else
          prefs.setInt(SharedpreferencesConstant.notificationCount, count + 1);

        count = prefs.getInt(SharedpreferencesConstant.notificationCount);
        print('after count : ${count}  ');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: screenSize.height * 0.2,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                Images.splashlogo,
                fit: BoxFit.fill,
                height: 179.19,
                width: 168.87,
                // height: screenSize.height*0.20,
                // width: screenSize.width*0.35,
              ),
            ),
            Container(
              child: Image.asset(
                Images.splashbootom,
                fit: BoxFit.fill,
                height: screenSize.height * 0.4,
                width: screenSize.width,
              ),
            ),
          ],
        ));
  }
}
