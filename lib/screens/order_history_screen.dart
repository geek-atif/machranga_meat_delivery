import '../util/util_function.dart';
import '../widgets/shimmer_order_history.dart';
import '../util/constant_text.dart';
import '../util/images.dart';
import '../util/no_data.dart';
import '../widgets/order_history_list.dart';
import '../models/order_history_model.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/order_history_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderHistory> _orderHistory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);
      print(userID);
      _getAllData(userID);
    });
  }

  _getAllData(userID) {
    var isJWTValid = UtilFunction.isJWTValid().then((isJWTValid) {
      if (!isJWTValid) {
        UtilFunction.logout(context);
        return;
      }

      setState(() {
        _isLoading = true;
      });

      Provider.of<OrderHistoryProvider>(context, listen: false)
          .getOrderHistory(userID)
          .then((orderHistoryModel) {
        // if (orderHistoryModel.errorStatus) {
        //   UtilFunction().showToast(orderHistoryModel.message);
        //   return;
        // }
        setState(() {
          _isLoading = false;
          _orderHistory = orderHistoryModel.orderHistory;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: _isLoading
            ? ShimmerOrderHistory(
                screenSize: screenSize,
              )
            : _orderHistory == null
                ? NoData(
                    image: Images.emptyHistory,
                    title: ConstantText.orderHead,
                    subTitle: ConstantText.orderHeadSub,
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _isLoading
                            ? ShimmerOrderHistory(
                                screenSize: screenSize,
                              )
                            : OrderHistoryList(
                                screenSize: screenSize,
                                orderHistory: _orderHistory,
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
