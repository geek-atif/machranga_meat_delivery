import '../models/cart_model.dart';
import '../util/loading.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/add_to_cart_provider.dart';
import '../util/constant.dart';
import '../util/constant_text.dart';
import '../util/images.dart';
import '../util/util_function.dart';
import 'package:provider/provider.dart';
import '../models/checkout_item.dart';
import '../util/my_singleton.dart';
import '../util/no_data.dart';
import '../util/styling.dart';
import '../widgets/proceed_to_checkout_button.dart';
import '../widgets/cart_list.dart';
import 'package:flutter/material.dart';
import '../widgets/shimmer_cart_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CheckOutItem> checkOutItems = List<CheckOutItem>();

  CartModel cartModel;
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    displayData();
  }

  displayData() async {
    print('CartScreen displayData() called');
    setState(() {
      _isLoading = true;
    });
    SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);

      MySingleton.shared.utilFunction
          .getCartDetail(userID, context)
          .then((cartModel) {
        setState(() {
          _isLoading = false;
          cartModel = cartModel;
          checkOutItems = cartModel.checkOutItem;
          UtilFunction.getTotalAmountSumForCartScreen(checkOutItems);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return _isLoading
        ? ShimmerCartScreen(
            screenSize: screenSize,
          )
        : checkOutItems.isEmpty
            ? NoData(
                image: Images.emptyCart,
                title: ConstantText.emptyCartHead,
                subTitle: ConstantText.emptyCartSub,
              )
            : Scaffold(
                floatingActionButton: Consumer<AddToCartProvider>(
                  builder: (ctx, addToCartProvider, child) => Visibility(
                    visible: UtilFunction.getTotalAmountSum() <= 0.0
                        ? false
                        : UtilFunction.getTotalAmountSum() > 0.0
                            ? true
                            : addToCartProvider.currentvisiablity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Constant.ADDRESS_PAYMENT_ROUTE_NAME);
                      },
                      child: ProceedToCheckOutButtion(
                        totalAmount: UtilFunction.getTotalAmountSumForCheckOut(
                            checkOutItems),
                        buttonContent: 'Proceed To Checkout',
                      ),
                    ),
                  ),
                ),
                backgroundColor: Theme.of(context).backgroundColor,
                body: SafeArea(
                  child: CartLayout(
                    screenSize: screenSize,
                    checkOutItems: checkOutItems,
                  ),
                ),
              );
  }
}

class CartLayout extends StatelessWidget {
  const CartLayout({
    Key key,
    @required this.screenSize,
    @required this.checkOutItems,
  }) : super(key: key);

  final Size screenSize;
  final List<CheckOutItem> checkOutItems;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(right: 8, left: 8),
        height: screenSize.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  'CART',
                  style: TextStyle(
                      fontFamily: 'Galano Grotesque',
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
              Container(
                height: screenSize.height * 0.35,
                width: double.infinity,
                child: CartList(
                  screenSize: screenSize,
                  checkOutItem: checkOutItems,
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Constant.COUPON_CODE_SCREEN,
                      arguments: UtilFunction.getTotalAmountSumForCartScreen(
                          checkOutItems));
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Have a promo code?',
                    style:
                        TextStyle(color: AppTheme.redButtonColor, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Divider(
                color: AppTheme.gryTextColor,
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Price(${checkOutItems.length} items):',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.05,
                  ),
                  Container(
                    child: Consumer<AddToCartProvider>(
                      builder: (ctx, addToCartProvider, child) => Visibility(
                        child: Text(
                          '‎₹‎${UtilFunction.getTotalAmountSum()}',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Delivery Fees:',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.05,
                  ),
                  Container(
                    child: Text(
                      '‎₹‎${MySingleton.shared.deliveryCharge}',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              if (MySingleton.shared.discountAmounts.isNotEmpty ||
                  MySingleton.shared.discount.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Discount: ',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.05,
                    ),
                    Container(
                      child: Text(
                        '₹‎${MySingleton.shared.discountAmounts}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              Divider(
                color: AppTheme.gryTextColor,
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Container(
                alignment: Alignment.topRight,
                child: Consumer<AddToCartProvider>(
                  builder: (ctx, addToCartProvider, child) => Text(
                    '‎Total : ₹‎${UtilFunction.getTotalAmountSumForCheckOut(checkOutItems)}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
