import '../models/cart_quantity_model.dart';
import '../models/product_model.dart';
import '../models/category_top_model.dart';
import '../models/category_model.dart';
import '../util/constant.dart';
import 'package:flutter/material.dart';

class ProductCategory extends StatelessWidget {
  List<CategoryModel> categoryModel;
  List<ProductModel> productModel;
  List<CartQuantityModel> cartQuantityModel;

  ProductCategory({
    @required this.categoryModel,
    @required this.productModel,
    @required this.cartQuantityModel,
  });

  _moveToCategory(BuildContext context, int categoryId) {
    List<CategoryTopModel> categoryTopModels = List<CategoryTopModel>();
    categoryModel.forEach((categoryModel) {
      if (categoryId == categoryModel.categoryId) {
        CategoryTopModel categoryTopModel = CategoryTopModel();
        categoryTopModel.categoryId = categoryModel.categoryId;
        categoryTopModel.categoryName = categoryModel.categoryName;
        categoryTopModel.imageURL = categoryModel.imageURL;
        categoryTopModel.selected = 1;
        categoryTopModels.add(categoryTopModel);
        return;
      }
    });

    categoryModel.forEach((categoryModel) {
      if (categoryId != categoryModel.categoryId) {
        CategoryTopModel categoryTopModel = CategoryTopModel();
        categoryTopModel.categoryId = categoryModel.categoryId;
        categoryTopModel.categoryName = categoryModel.categoryName;
        categoryTopModel.imageURL = categoryModel.imageURL;
        categoryTopModel.selected = 0;
        categoryTopModels.add(categoryTopModel);
      }
    });

    CategoryProductModel categoryProductModel = CategoryProductModel();
    categoryProductModel.categoryTopModel = categoryTopModels;
    categoryProductModel.productModel = productModel;
    categoryProductModel.cartQuantityModels = cartQuantityModel;

    Navigator.of(context).pushNamed(Constant.CATERGORY_ROUTE_NAME,
        arguments: categoryProductModel);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.12,
      width: screenSize.width,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categoryModel.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            _moveToCategory(context, categoryModel[index].categoryId);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: screenSize.width * 0.15,
                child: Image.network(
                  categoryModel[index].imageURL,
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.22,
                height: screenSize.height * 0.022,
              ),
              //  SizedBox(
              //   width: screenSize.width * 0.25,
              //   height: screenSize.height * 0.022,
              // ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  categoryModel[index].categoryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Muli',
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
