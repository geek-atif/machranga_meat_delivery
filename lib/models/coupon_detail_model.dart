class CouponDetailModel {
  bool errorStatus;
  String message;
  List<CouponDetail> couponDetail;
}

class CouponDetail {
  int couponId;
  String couponDesc;
  String couponName;
  String couponCode;
  String couponPer;
  String couponAmt;
  String maxAmtStatus;
}
