import '../models/order_place_model.dart';

class OrderPlaceResponse {
  OrderPlaceModel orderPlaceModel;
  OrderPlaceResponse.fromJson(Map<String, dynamic> json) {
    orderPlaceModel = new OrderPlaceModel();
    orderPlaceModel.errorStatus = json['errorStatus'];
    orderPlaceModel.message = json['message'];
  }
}
