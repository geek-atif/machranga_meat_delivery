import '../repository/user_detail_respository.dart';
import '../util/my_singleton.dart';
import '../util/util_function.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../util/loading.dart';
import '../providers/add_to_cart_provider.dart';
import 'package:provider/provider.dart';
import '../util/constant.dart';
import '../util/sharedpreferences_constant.dart';
import '../util/styling.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/proceed_to_checkout_button.dart';
import 'package:flutter/material.dart';
import '../models/checkout_item.dart';

class AddressPaymentScreen extends StatefulWidget {
  @override
  _AddressPaymentScreenState createState() => _AddressPaymentScreenState();
}

class _AddressPaymentScreenState extends State<AddressPaymentScreen> {
  Razorpay _razorpay;
  int groupValue = -1;
  int paymentMode;
  String address = '';
  int userId;
  String addressId;
  SharedPreferences prefs;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  List<CheckOutItem> checkOutItems = List<CheckOutItem>();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(String amount) async {
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Provider.of<AddToCartProvider>(context, listen: false)
        .allProductAvailable(
            userId, addressId, address, 'razorpay', '112', '112', checkOutItems)
        .then((orderPlaceModel) {
      if (orderPlaceModel.errorStatus) {
        Navigator.of(context).pushReplacementNamed(
            Constant.BOTTOM_NAVIGATION_NAME,
            arguments: 1);
        MySingleton.shared.utilFunction.showToast(orderPlaceModel.message);
      } else {
        UserDetailRespository().getRazorpayDetails().then((value) {
          var options = {
            'key': value.razorpaykey,
            'amount': num.parse(amount) * 100,
            'name': 'Machranga',
            'description': 'Machranga Product',
            'prefill': {'contact': '', 'email': ''},
            'external': {
              'wallets': ['paytm']
            }
          };

          setState(() {
            _isLoading = false;
          });

          try {
            _razorpay.open(options);
          } catch (e) {
            debugPrint(e);
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    print('_handlePaymentSuccess');

    setState(() {
      _isLoading = true;
    });

    Provider.of<AddToCartProvider>(context, listen: false)
        .placeOrder(
            userId,
            addressId,
            address,
            'razorpay',
            paymentSuccessResponse.paymentId,
            paymentSuccessResponse.orderId == null
                ? ''
                : paymentSuccessResponse.orderId,
            checkOutItems)
        .then((orderPlaceModel) {
      setState(() {
        _isLoading = false;
      });

      if (orderPlaceModel.errorStatus) {
       UtilFunction().showToast(orderPlaceModel.message);
      } else {
        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(false);
        Map response = {
          'orderPlaceModel': orderPlaceModel,
          'checkOutItems': checkOutItems
        };
        Navigator.of(context)
            .pushNamed(Constant.ORDER_SUCCESS_ROUTE_NAME, arguments: response);
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('_handlePaymentError');
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          'Payment Failed',
          style: TextStyle(color: AppTheme.redButtonColor),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('_handleExternalWallet');
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          'Payment Failed',
          style: TextStyle(color: AppTheme.redButtonColor),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    getUserAddress();
    print('_AddressPaymentScreenState didChangeDependencies');
    super.didChangeDependencies();
    getCheckOutData();
  }

  getCheckOutData() async {
    print('AddressPayment getCheckOutData() called');
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);
      print(userID);
      MySingleton.shared.utilFunction
          .getCartDetail(userID, context)
          .then((cartModel) {
        setState(() {
          _isLoading = false;
          checkOutItems = cartModel.checkOutItem;
          UtilFunction.getTotalAmountSumForCartScreen(checkOutItems);
        });
      });
    });
  }

  getUserAddress() async {
    prefs = await SharedPreferences.getInstance();
    var _address = prefs.getString(SharedpreferencesConstant.selectedAddress);
    var _userId = prefs.getInt(SharedpreferencesConstant.userId);
    var _addressId =
        prefs.getString(SharedpreferencesConstant.selectedAddressId);
    setState(() {
      address = _address;
      userId = _userId;
      addressId = _addressId;
    });
  }

  void selectRadio(int value) {
    setState(() {
      groupValue = value;
    });
  }

  Future<void> _cod() async {
    if (groupValue == -1) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Please Select Payment Method',
            style: TextStyle(color: AppTheme.redButtonColor),
          ),
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    if (address == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Please add address',
            style: TextStyle(color: AppTheme.redButtonColor),
          ),
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    if (groupValue == 1) {
      openCheckout(UtilFunction.getCheckOutTotalAmount().toString());
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Provider.of<AddToCartProvider>(context, listen: false)
        .placeOrder(
      userId,
      addressId,
      address,
      'cod',
      ' ',
      ' ',
      checkOutItems,
    )
        .then((orderPlaceModel) {
      setState(() {
        _isLoading = false;
      });

      if (orderPlaceModel.errorStatus) {
        Navigator.of(context).pushReplacementNamed(
            Constant.BOTTOM_NAVIGATION_NAME,
            arguments: 1);
        MySingleton.shared.utilFunction.showToast(orderPlaceModel.message);
      } else {
        Map response = {
          'orderPlaceModel': orderPlaceModel,
          'checkOutItems': checkOutItems
        };
        Navigator.of(context)
            .pushNamed(Constant.ORDER_SUCCESS_ROUTE_NAME, arguments: response);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: MyAppBar(
          title: 'ADDRESS AND PAYMENT',
        ),
        floatingActionButton: _isLoading
            ? Loading(
                loadingMessage: '',
              )
            : Container(
                child: GestureDetector(
                  onTap: () {
                    _cod();
                  },
                  child: ProceedToCheckOutButtion(
                    totalAmount: UtilFunction.getCheckOutTotalAmount(),
                    buttonContent: 'Proceed To Payment',
                  ),
                ),
              ),
        body: Container(
          margin: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: screenSize.height * 0.03,
              ),
              Text(
                'DELIVER HERE',
                style: TextStyle(fontFamily: 'Galano Grotesque', fontSize: 16),
              ),
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              address == null
                  ? addressNoDataCard(screenSize)
                  : withaddressDataCard(screenSize, address),
              SizedBox(
                height: screenSize.height * 0.04,
              ),
              Text(
                'PAYMENT',
                style: TextStyle(fontFamily: 'Galano Grotesque', fontSize: 16),
              ),
              if (MySingleton.shared.codModelEnable.isNotEmpty &&
                  MySingleton.shared.codModelEnable.toLowerCase() == 'true')
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: groupValue,
                        activeColor: AppTheme.redButtonColor,
                        onChanged: selectRadio,
                      ),
                      Text(
                        'Cash On Delivery',
                        style: TextStyle(fontFamily: 'Muli', fontSize: 14),
                      ),
                    ],
                  ),
                ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      activeColor: AppTheme.redButtonColor,
                      groupValue: groupValue,
                      onChanged: selectRadio,
                    ),
                    Text(
                      'Razorpay',
                      style: TextStyle(fontFamily: 'Muli', fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Card withaddressDataCard(Size screenSize, String address) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(5.0),
        width: screenSize.width * 0.9,
        height: screenSize.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    address,
                    style: TextStyle(
                        color: Colors.black, fontSize: 15, fontFamily: 'Muli'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(Constant.ADDRESS_ROUTE_NAME);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.serachColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Change or edit address',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Muli'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card addressNoDataCard(Size screenSize) {
    return Card(
      elevation: 2,
      child: Container(
        width: screenSize.width * 0.9,
        height: screenSize.height * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Constant.ADDRESS_ROUTE_NAME);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.serachColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Add Address',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Muli'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
