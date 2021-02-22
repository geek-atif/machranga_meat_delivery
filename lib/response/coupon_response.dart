import '../models/coupon_detail_model.dart';

class CouponCodeResponse {
  CouponDetailModel couponDetailModel;
  CouponCodeResponse.fromJson(Map<String, dynamic> json) {
    print('CouponCodeResponse : json ${json}');
    couponDetailModel = CouponDetailModel();
    couponDetailModel.errorStatus = json['errorStatus'];
    couponDetailModel.message = json['message'];
    if (json['data'] != '') {
      List<CouponDetail> couponDetail = new List<CouponDetail>();
      json['data'].forEach((v) {
        couponDetail.add(parseData(v));
      });
      couponDetailModel.couponDetail = couponDetail;
    }
  }

  CouponDetail parseData(v) {
    CouponDetail couponDetail = CouponDetail();
    couponDetail.couponId = v['id'];
    couponDetail.couponDesc = v['coupon_desc'].toString();
    couponDetail.couponName = v['coupon_name'].toString();
    couponDetail.couponCode = v['coupon_code'].toString();
    couponDetail.couponPer = v['coupon_per'].toString();
    couponDetail.couponAmt = v['coupon_amt'].toString();
    couponDetail.maxAmtStatus = v['max_amt_status'].toString();
    return couponDetail;
  }
}
