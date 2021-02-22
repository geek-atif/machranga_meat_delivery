import '../providers/user_detail_provider.dart';
import '../util/constant.dart';
import '../util/sharedpreferences_constant.dart';
import '../util/util_function.dart';
import '../widgets/my_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/home_repository.dart';
import '../util/loading.dart';
import '../util/my_singleton.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/coupon_detail_model.dart';

class CouponCodeScreen extends StatefulWidget {
  @override
  _CouponCodeScreenState createState() => _CouponCodeScreenState();
}

class _CouponCodeScreenState extends State<CouponCodeScreen> {
  var _isLoading = false;
  var _isLoadingSub = false;
  var userId;
  var couponCodeM = '';
  var totalAmount = 0.0;

  List<CouponDetail> couponDetail = List<CouponDetail>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('didChangeDependencies()');
    _getAllData();
  }

  Future<void> _getAllData() async {
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }

    await SharedPreferences.getInstance().then((prefs) {
      userId = prefs.getInt(SharedpreferencesConstant.userId);
    });

    setState(() {
      _isLoading = true;
    });

    CouponDetailModel couponDetailModel = await HomeRepository().getCoupon();
    couponDetail = couponDetailModel.couponDetail;
    setState(() {
      _isLoading = false;
    });
  }

  void applyCoupon(BuildContext context, String couponCode) async {
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }

    if (couponCode == null || couponCode.isEmpty) {
      MySingleton.shared.utilFunction.showToast("Please Enter Coupon Code.");
      return;
    }

    Dialogs.showLoadingDialog(context, _keyLoader); //invoking login

    Provider.of<UserDetailProvider>(context, listen: false)
        .validateCoupon(couponCode, userId, totalAmount)
        .then((couponApplyModel) {
      if (couponApplyModel.errorStatus) {
        UtilFunction().showToast(couponApplyModel.message);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        return;
      }

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      MySingleton.shared.utilFunction.showToast(couponApplyModel.message);
      if (couponApplyModel.errorStatus) {
        return;
      }

      MySingleton.shared.discountAmounts = '';
      MySingleton.shared.discount = '';

      MySingleton.shared.discountAmounts =
          couponApplyModel.couponApply.discountAmt;
      MySingleton.shared.discount = couponApplyModel.couponApply.discount;
      MySingleton.shared.utilFunction
          .showToastGreen(couponApplyModel.couponApply.saveMessage);
      Navigator.of(context)
          .pushReplacementNamed(Constant.BOTTOM_NAVIGATION_NAME, arguments: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    totalAmount = ModalRoute.of(context).settings.arguments;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: getEditText(),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                applyCoupon(context, couponCodeM);
              },
              child: Text(
                'APPLY',
                style: TextStyle(color: AppTheme.redButtonColor),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Loading(
                loadingMessage: '',
              )
            : couponDetail == null
                ? Center(child: Text('No Data'))
                : Container(
                    margin: EdgeInsets.only(bottom: 60),
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: couponDetail.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        padding: EdgeInsets.all(2.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    couponDetail[index].couponCode,
                                    style: TextStyle(
                                        fontFamily: 'Galano Grotesque'),
                                  ),
                                ),
                                _isLoadingSub
                                    ? Loading(
                                        loadingMessage: '',
                                      )
                                    : FlatButton(
                                        onPressed: () {
                                          applyCoupon(context,
                                              couponDetail[index].couponCode);
                                        },
                                        child: Text(
                                          'APPLY',
                                          style: TextStyle(
                                              color: AppTheme.redButtonColor),
                                        ),
                                      ),
                              ],
                            ),
                            Html(
                              data: couponDetail[index].couponDesc,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Container getEditText() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        onChanged: (value) {
          couponCodeM = value;
        },
        onSubmitted: (value) {
          couponCodeM = value;
        },
        decoration: InputDecoration(
            border: InputBorder.none, hintText: 'Enter promo code here'),
      ),
    );
  }
}
