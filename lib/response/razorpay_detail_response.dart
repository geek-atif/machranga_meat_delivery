import '../models/razorpay_detail_model.dart';

class RazorpayDetailResponse {
  RazorpayDetailsModel razorpayDetailsModel;
  RazorpayDetailResponse.fromJson(Map<String, dynamic> json) {
    razorpayDetailsModel = RazorpayDetailsModel();
    razorpayDetailsModel.errorStatus = json['errorStatus'];
    razorpayDetailsModel.message = json['message'];
    if (json['data'] != '') {
      json['data'].forEach((v) {
        razorpayDetailsModel.razorpaykey = v['razorpay_key'];
        razorpayDetailsModel.razorpaySecret = v['razorpay_secret'];
      });
    }
  }
}
