import 'package:Machranga/widgets/shimmer_notification.dart';

import '../models/banner_model.dart';
import '../util/constant.dart';
import '../util/constant_text.dart';
import '../util/images.dart';
import '../util/no_data.dart';
import '../util/sharedpreferences_constant.dart';
import '../util/util_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/loading.dart';
import '../providers/user_detail_provider.dart';
import '../util/my_singleton.dart';
import 'package:provider/provider.dart';
import '../models/notification_response_model.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _isLoading = false;
  List<NotificationData> notificationData = List<NotificationData>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNotication();
  }

  void getAllNotication() {
    var isJWTValid = UtilFunction.isJWTValid().then((isJWTValid) {
      if (!isJWTValid) {
        UtilFunction.logout(context);
        return;
      }

      setState(() {
        _isLoading = true;
      });
      var userId = MySingleton.shared.userId;

      Provider.of<UserDetailProvider>(context, listen: false)
          .getNotification(userId)
          .then((notificationResponseModel) {
        // if (notificationResponseModel.errorStatus) {
        //   UtilFunction().showToast(notificationResponseModel.message);
        //   return;
        // }

        setState(() {
          notificationData = notificationResponseModel.notificationData;
          _isLoading = false;
        });
      });

      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt(SharedpreferencesConstant.notificationCount, 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var noNotification = Images.noNotification;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(
        title: 'Notification',
      ),
      backgroundColor: Colors.white,
      body: Container(
        //margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: _isLoading
            ? ShimmerNotification(screenSize: screenSize)
            : notificationData == null || notificationData.isEmpty
                ? NoData(
                    image: noNotification,
                    title: 'NO NOTIFICATION',
                    subTitle: ConstantText.noNotification,
                  )
                : ListView.builder(
                    itemCount: notificationData.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                      child: NotificationCard(
                        notificationData: notificationData[index],
                      ),
                    ),
                  ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notificationData;
  const NotificationCard({
    @required this.notificationData,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        moveToScreen(notificationData, context);
      },
      child: Card(
        child: ListTile(
          leading: Image.asset(Images.notificationList),
          title: Text(
            notificationData.title,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Galano Grotesque',
            ),
          ),
          subtitle: Text(
            notificationData.desc,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Muli',
            ),
          ),
        ),
      ),
    );
  }

  void moveToScreen(NotificationData notificationData, BuildContext context) {
    print('moveToScreen type : ${notificationData.type}');
    if (notificationData.type == 'Order') {
      Navigator.of(context).pushNamed(
          Constant.ORDER_HISTORY_SINGLE_NOTIFICATION_ROUTE_NAME,
          arguments: notificationData.orderId);
    } else if (notificationData.type == 'banner') {
      BannerModel bannerModel = BannerModel();
      bannerModel.bannerId = int.parse(notificationData.bannerId);
      bannerModel.bannerTitle = notificationData.title;
      Navigator.of(context).pushNamed(Constant.BANNER_DETAILS_ROUTE_NAME,
          arguments: bannerModel);
    } else if (notificationData.type == 'product') {
      Navigator.of(context).pushNamed(
          Constant.PRODUCT_DETAIL_NOTIFICATION_DETAILS_ROUTE_NAME,
          arguments: notificationData.productId);
    } else {
      Navigator.of(context).pushNamed(Constant.BOTTOM_NAVIGATION_NAME);
    }
  }
}
