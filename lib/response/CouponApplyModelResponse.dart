import '../models/coupon_apply_model.dart';

class CouponApplyModelResponse {
  CouponApplyModel couponApplyModel;
  CouponApplyModelResponse.fromJson(Map<String, dynamic> json) {
    couponApplyModel = CouponApplyModel();
    couponApplyModel.errorStatus = json['errorStatus'];
    couponApplyModel.message = json['message'];
    if (json['data'].toString().isNotEmpty && json['data'] != null) {
      CouponApply couponApply = CouponApply();
      couponApply.success = json['data']['success'];
      couponApply.meesage = json['data']['msg'];
      couponApply.couponId = json['data']['coupon_id'];
      couponApply.couponsMessage = json['data']['coupons_msg'];
      couponApply.saveMessage = json['data']['you_save_msg'] == null
          ? ''
          : json['data']['you_save_msg'].toString();
      couponApply.price =
          json['data']['price'] == null ? '' : json['data']['price'].toString();
      couponApply.payableAmt = json['data']['payable_amt'] == null
          ? ''
          : json['data']['payable_amt'].toString();
      couponApply.discount = json['data']['discount'] == null
          ? ''
          : json['data']['discount'].toString();
      couponApply.discountAmt = json['data']['discount_amt'] == null
          ? ''
          : json['data']['discount_amt'].toString();
      couponApplyModel.couponApply = couponApply;
    }
  }

  CouponApply parseData(v) {
    CouponApply couponApply = CouponApply();
    couponApply.success = v['success'];
    couponApply.meesage = v['msg'];
    couponApply.couponId = v['coupon_id'];
    couponApply.couponsMessage = v['coupons_msg'];
    couponApply.saveMessage = v['you_save_msg'];
    couponApply.price = v['price'];
    couponApply.payableAmt = v['payable_amt'];
    couponApply.discount = v['discount'];
    couponApply.discountAmt = v['discount_amt'];
    return couponApply;
  }
}
