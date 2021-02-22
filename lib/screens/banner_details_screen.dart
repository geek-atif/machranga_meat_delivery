import '../widgets/shimmer_vertical_product.dart';
import '../models/banner_model.dart';
import '../util/util_function.dart';
import '../providers/home_provider.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_quantity_model.dart';
import '../providers/add_to_cart_provider.dart';
import '../util/constant.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/proceed_to_checkout_button.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import 'package:flutter/material.dart';
import '../widgets/vertical_column_product.dart';

class BannerDetailScreen extends StatefulWidget {
  @override
  _BannerDetailScreenState createState() => _BannerDetailScreenState();
}

class _BannerDetailScreenState extends State<BannerDetailScreen> {
  List<ProductModel> productModels = List<ProductModel>();
  List<CartQuantityModel> cartQuantityModel;
  String bannerTitle;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildListProduct();
  }

  _buildListProduct() async {
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }

    BannerModel bannerModel = ModalRoute.of(context).settings.arguments;
    bannerTitle = bannerModel.bannerTitle;
    setState(() {
      _isLoading = true;
    });

    SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);
      Provider.of<HomeProvider>(context, listen: false)
          .getBannerProduct(userID, bannerModel.bannerId)
          .then((productListModel) {
            if(productListModel.errorStatus){
              UtilFunction().showToast(productListModel.message);
              return;
            }
        setState(() {
          _isLoading = false;
          productModels = productListModel.productModels;
          cartQuantityModel = productListModel.cartQuantityModel;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return _isLoading && bannerTitle != null
        ? Scaffold(
            body: SafeArea(
              child: ShimmerVerticalProduct(
                screenSize: screenSize,
              ),
            ),
          )
        : Scaffold(
            appBar: MyAppBar(
              title: bannerTitle,
            ),
            floatingActionButton: Consumer<AddToCartProvider>(
              builder: (ctx, addToCartProvider, child) => Visibility(
                visible: UtilFunction.getTotalAmountSum() <= 0.0
                    ? false
                    : addToCartProvider.currentvisiablity,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        Constant.BOTTOM_NAVIGATION_NAME,
                        arguments: 1);
                  },
                  child: ProceedToCheckOutButtion(
                    totalAmount: addToCartProvider.totalAmount,
                    buttonContent: 'Go To Cart',
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: VerticalColumnProduct(
                  productModels: productModels,
                  cartQuantityModels: cartQuantityModel,
                ),
              ),
            ),
          );
  }
}
