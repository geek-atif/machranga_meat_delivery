import '../widgets/shimmer_vertical_category_product.dart';
import '../providers/home_provider.dart';
import '../util/util_function.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_quantity_model.dart';
import '../providers/add_to_cart_provider.dart';
import '../util/constant.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/proceed_to_checkout_button.dart';
import 'package:provider/provider.dart';
import '../models/category_top_model.dart';
import '../models/product_model.dart';
import '../widgets/custom_tab_view.dart';
import '../widgets/vertical_column_product.dart';
import 'package:flutter/material.dart';

class CatergoryScreen extends StatefulWidget {
  @override
  _CatergoryScreenState createState() => _CatergoryScreenState();
}

class _CatergoryScreenState extends State<CatergoryScreen> {
  int initPosition = 0;
  CategoryProductModel categoryProductModel;
  List<ProductModel> productModels = List<ProductModel>();
  List<CartQuantityModel> _cartQuantityModels = List<CartQuantityModel>();
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
    categoryProductModel =
        ModalRoute.of(context).settings.arguments as CategoryProductModel;

    setState(() {
      _isLoading = true;
    });

    SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);
      print(userID);
      Provider.of<HomeProvider>(context, listen: false)
          .getProductDetails(userID)
          .then((productListModel) {
        if (productListModel.errorStatus) {
          UtilFunction().showToast(productListModel.message);
          return;
        }
        setState(() {
          _isLoading = false;
          productModels = productListModel.productModels;
          _cartQuantityModels = productListModel.cartQuantityModel;
          UtilFunction.getTotalAmountSumForProducts(
              productModels, _cartQuantityModels, context);
        });
      });
    });
  }

  List<ProductModel> getProductByCatgeoryId(
      int categoryId, List<ProductModel> productModels) {
    List<ProductModel> filtterProductModel = List<ProductModel>();
    productModels.forEach((localProductModels) {
      if (localProductModels.categoryId == categoryId) {
        ProductModel productModel = ProductModel();
        productModel.productId = localProductModels.productId;
        productModel.categoryId = localProductModels.categoryId;
        productModel.subCategoryId = localProductModels.subCategoryId;
        productModel.productTitle = localProductModels.productTitle;
        productModel.productSlug = localProductModels.productSlug;
        productModel.productDesc = localProductModels.productDesc;
        productModel.imageURL = localProductModels.imageURL;
        productModel.sellingPrice = localProductModels.sellingPrice;
        productModel.productStock = localProductModels.productStock;
        productModel.todayDeal = localProductModels.todayDeal;
        //productModel.todayDealDate = localProductModels.todayDealDate;
        productModel.is_featured = localProductModels.is_featured;
        productModel.isAdded = localProductModels.isAdded;
        filtterProductModel.add(productModel);
      }
    });
    return filtterProductModel;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
            body: SafeArea(
              child: ShimmerVerticalCategoryProduct(
                screenSize: screenSize,
              ),
            ),
          )
        : Scaffold(
            appBar: MyAppBar(
              title: 'MENU',
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
                child: CustomTabView(
                  initPosition: initPosition,
                  itemCount: categoryProductModel.categoryTopModel.length,
                  tabBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: screenSize.width * 0.15,
                          child: Image.network(
                            categoryProductModel
                                .categoryTopModel[index].imageURL,
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.2,
                          height: screenSize.height * 0.022,
                        ),
                        // SizedBox(
                        //   width: screenSize.width * 0.05,
                        //   height: screenSize.height * 0.022,
                        // ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            categoryProductModel
                                .categoryTopModel[index].categoryName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Muli',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  pageBuilder: (context, index) {
                    return VerticalColumnProduct(
                      productModels: getProductByCatgeoryId(
                          categoryProductModel
                              .categoryTopModel[index].categoryId,
                          productModels),
                      cartQuantityModels: _cartQuantityModels,
                    );
                  },
                  onPositionChange: (index) {
                    initPosition = index;
                  },
                  onScroll: (position) => print(''),
                ),
              ),
            ),
          );
  }
}
