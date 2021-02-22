import '../repository/order_place_repository.dart';
import '../util/util_function.dart';

class MySingleton {
  static final MySingleton _singleton = MySingleton._internal();
  Map checkoutMap = {};
  double totalAmount = 0.0;
  int userId=0;
  var utilFunction = new UtilFunction();
  OrderPlaceRepository orderPlaceRepository = OrderPlaceRepository();
  double deliveryCharge = 0.0;
  String deliveryInstruction = '';
  String codModelEnable = '';
  String razorpayEnable = '';
  String discountAmounts = '';
  String discount = '';

  factory MySingleton() {
    return _singleton;
  }
  MySingleton._internal();
  static MySingleton get shared => _singleton;
}
