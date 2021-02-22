import '../util/my_singleton.dart';
import '../widgets/my_dialogs.dart';
import '../widgets/vertical_column_product.dart';
import '../models/cart_quantity_model.dart';
import '../providers/add_to_cart_provider.dart';
import '../providers/home_provider.dart';
import '../util/constant.dart';
import '../util/sharedpreferences_constant.dart';
import '../util/util_function.dart';
import '../widgets/proceed_to_checkout_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ProductModel> productModels = List<ProductModel>();
  List<CartQuantityModel> _cartQuantityModels = List<CartQuantityModel>();
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  double totalAmount = UtilFunction.getTotalAmountSum();

  @override
  void initState() {
    super.initState();
    MySingleton.shared.totalAmount = 0.0;
  }

  serachTheProduct(searchKeyWord) async {
    print(' searchKeyWord : ${searchKeyWord}');
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }

    MySingleton.shared.totalAmount = 0.0;
    Dialogs.showLoadingDialog(context, keyLoader);
    SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);
      print(userID);
      Provider.of<HomeProvider>(context, listen: false)
          .getSearchProduct(userID, searchKeyWord)
          .then((productListModel) {
        if (productListModel.errorStatus) {
          UtilFunction().showToast(productListModel.message);
          return;
        }
        setState(() {
          if (productListModel.errorStatus ||
              productListModel.productModels.isEmpty ||
              productListModel.productModels == null) {
            Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
            return;
          }
          productModels = productListModel.productModels;
          _cartQuantityModels = productListModel.cartQuantityModel;
          Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
        });

        totalAmount = UtilFunction.getTotalAmountSumForProducts(
            productModels, _cartQuantityModels, context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('SearchScreen totalAmount : $totalAmount');
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Consumer<AddToCartProvider>(
          builder: (ctx, addToCartProvider, child) => Visibility(
            visible: totalAmount <= 0.0
                ? false
                : totalAmount > 0.0
                    ? true
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: getEditText(),
          actions: <Widget>[
            Icon(
              Icons.search,
              color: AppTheme.redButtonColor,
              size: 25.0,
            ),
            Text('    '),
          ],
        ),
        backgroundColor: Colors.white,
        body: productModels == null
            ? Center(
                child: Text('NO Data'),
              )
            : VerticalColumnProduct(
                productModels: productModels,
                cartQuantityModels: _cartQuantityModels,
              ),
      ),
    );
  }

  Container getEditText() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          if (value.length >= 3) {
            print('value : ${value}');
            serachTheProduct(value);
          }
        },
        onSubmitted: (value) {},
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by product and category'),
      ),
    );
  }
}

/*
class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    homePageModel = ModalRoute.of(context).settings.arguments as HomePageModel;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.gryButtonColor,
        body: Container(
          margin: EdgeInsets.all(10),
          child: SearchBar<ProductModel>(
            loader: Loading(
              loadingMessage: '',
            ),
            searchBarStyle: SearchBarStyle(
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(45),
            ),
            hintText: "Search Products",
            hintStyle: TextStyle(
              color: Color(0xFFC9C9C9),
            ),
            icon: Icon(
              Icons.search,
              color: Color(0xFFDD2121),
            ),
            onSearch: search,
            onItemFound: (ProductModel productModel, int index) {
              return ProductCardVer(
                screenSize: screenSize,
                productModels: productModel,
                // cartQuantityModel: cartQuantityModels.firstWhere(
                //     (element) => element.productId == productModel.productId,
                //     orElse: () => null),
                cartQuantityModel: null,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<ProductModel>> search(String searchKeyWord) async {
    print('search ${searchKeyWord}');
    List<ProductModel> productModel = List<ProductModel>();

    productModel = homePageModel.productModel
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchKeyWord.toLowerCase()))
        .toList();
    await Future.delayed(Duration(seconds: 1));
    return productModel;
  }
}*/

/*
class VerticalColumnProduct extends StatelessWidget {
  List<ProductModel> productModels;
  VerticalColumnProduct({this.productModels});
  int id = 1;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.8,
      margin: EdgeInsets.only(bottom: 60),
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
                color: AppTheme.boxShadow,
                blurRadius: 15.0,
              ),
            ],
          ),
          child: ProductCardVer(
            screenSize: screenSize,
            productModels: productModels[index],
          ),
        ),
      ),
    );
  }
}
*/
