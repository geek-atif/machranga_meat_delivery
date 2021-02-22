import './screens/faq_screen.dart';
import './screens/term_and_condition_screen.dart';
import './screens/update_address_screen.dart';
import './providers/order_history_provider.dart';
import './screens/coupon_code_screen.dart';
import './screens/order_history_screen.dart';
import './providers/add_to_cart_provider.dart';
import './providers/home_provider.dart';
import './providers/login_provider.dart';
import './providers/signup_provider.dart';
import './screens/add_address_screen.dart';
import './screens/address_payment_screen.dart';
import './screens/address_screen.dart';
import './screens/catergory_screen.dart';
import './screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:provider/provider.dart';
import './screens/bottom_navigation_screen.dart';
import './screens/home_screen.dart';
import './screens/otp_screen.dart';
import './screens/signup_screen.dart';
import './screens/login_screen.dart';
import './util/constant.dart';
import './screens/welcome_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'providers/user_detail_provider.dart';
import 'screens/notification_screen.dart';
import 'screens/order_history_single_detail_screen.dart';
import 'screens/order_history_single_detail_screen_notification.dart';
import 'screens/order_success_screen.dart';
import './screens/search_screen.dart';
import 'screens/otp_screen_forget_password.dart';
import 'screens/product_detail_screen_notification.dart';
import 'screens/reset_password_screen.dart';
import 'screens/update_profile_Screen.dart';
import './screens/banner_details_screen.dart';
//import 'service/push_notification_manager.dart';

void main() {
  //SharedPreferences.setMockInitialValues({});
  // runApp(DevicePreview(
  //   usePreferences: false,
  //   builder: (context) => MyApp(),
  // ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    services.SystemChrome.setPreferredOrientations([
      services.DeviceOrientation.portraitUp,
      services.DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: LoginProvider(),
        ),
        ChangeNotifierProvider.value(
          value: SignupProvider(),
        ),
        ChangeNotifierProvider.value(
          value: HomeProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AddToCartProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UserDetailProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrderHistoryProvider(),
        ),
      ],
      child: MaterialApp(
        //  locale: DevicePreview.of(context).locale, // <--- Add the locale
        //  builder: DevicePreview.appBuilder, //

        title: 'Machranga',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          primaryColor: Colors.black, // Color.fromRGBO(231, 33, 33, 1),
          primaryColorBrightness: Brightness.light,
          accentColor: Colors.green,
          backgroundColor: Colors.white,
          accentColorBrightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        //home: PushNotificationManagere(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => SplashScreen(),
          Constant.WELCOME_ROUTE_NAME: (ctx) => WelcomeScreen(),
          Constant.LOGIN_ROUTE_NAME: (ctx) => LoginScreen(),
          Constant.SIGNUP_ROUTE_NAME: (ctx) => SignupScreen(),
          Constant.OTP_ROUTE_NAME: (ctx) => OtpScreen(),
          Constant.HOME_ROUTE_NAME: (ctx) => HomeScreen(),
          Constant.BOTTOM_NAVIGATION_NAME: (ctx) => MyBottomNavScreen(),
          Constant.CATERGORY_ROUTE_NAME: (ctx) => CatergoryScreen(),
          Constant.ADDRESS_PAYMENT_ROUTE_NAME: (ctx) => AddressPaymentScreen(),
          Constant.ADDRESS_ROUTE_NAME: (ctx) => AddressScreen(),
          Constant.ADD_ADDRESS_ROUTE_NAME: (ctx) => AddAddressScreen(),
          Constant.ORDER_SUCCESS_ROUTE_NAME: (ctx) => OrderSuccessScreen(),
          Constant.ORDER_HISTORY_SCREEN_ROUTE_NAME: (ctx) =>
              OrderHistoryScreen(),
          //Constant.PRODUCT_DETAIL_SCREEN: (ctx) => ProductDetailScreen(),
          Constant.PROFILE_UPDATE_SCREEN: (ctx) => UpdateProfileScreen(),
          Constant.ORDER_HISTORY_SINGLE_SCREEN: (ctx) =>
              OrderHistorySingleDetailScreen(),
          Constant.SEARCH_SCREEN: (ctx) => SearchScreen(),
          Constant.COUPON_CODE_SCREEN: (ctx) => CouponCodeScreen(),
          Constant.OTP_FORGOT_PASSWORD_ROUTE_NAME: (ctx) =>
              OtpScreenForgetPassword(),
          Constant.RESET_PASSWORD_ROUTE_NAME: (ctx) => RestPasswordScreen(),
          Constant.UPDATE_ADDRESS_ROUTE_NAME: (ctx) => UpdateAddressScreen(),
          Constant.TERMANDCOD_ROUTE_NAME: (ctx) => TermAndConditionScreen(),
          Constant.FAQS_ROUTE_NAME: (ctx) => FAQScreen(),
          Constant.BANNER_DETAILS_ROUTE_NAME: (ctx) => BannerDetailScreen(),
          Constant.NOTIFICATION_DETAILS_ROUTE_NAME: (ctx) =>
              NotificationScreen(),
          Constant.PRODUCT_DETAIL_NOTIFICATION_DETAILS_ROUTE_NAME: (ctx) =>
              ProductDetailScreenNotification(),
          Constant.ORDER_HISTORY_SINGLE_NOTIFICATION_ROUTE_NAME: (ctx) =>
              OrderHistorySingleDetailScreenNotification(),
         // "PushNotificationManagere": (ctx) => PushNotificationManagere(),
        },
      ),
    );
  }
}
