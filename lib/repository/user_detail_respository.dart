import '../response/notification_response.dart';
import '../models/notification_response_model.dart';
import '../models/coupon_apply_model.dart';
import '../response/CouponApplyModelResponse.dart';
import '../response/forgot_password_response.dart';
import '../models/user_deatil_model.dart';
import '../response/user_detail_response.dart';
import '../api_base_helper/api_base_helper.dart';
import '../response/pin_code_response.dart';
import '../models/pinCodeModel.dart';
import '../models/razorpay_detail_model.dart';
import '../response/razorpay_detail_response.dart';
import '../models/forgot_password_model.dart';

class UserDetailRespository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserDeatilModel> getUserDetail(int userId) async {
    final response = await _helper.get("/getUserDetails?userId=$userId");
    UserDeatilModel homeModel =
        UserDetailResponse.fromJson(response).userDeatilModel;
    return homeModel;
  }

  Future<PinCodeModel> getPinDetails(String pinCode) async {
    final response = await _helper.get("/isPinCodeValid?pinCode=$pinCode");
    PinCodeModel pinCodeModel = PinCodeResponse.fromJson(response).pinCodeModel;
    return pinCodeModel;
  }

  Future<RazorpayDetailsModel> getRazorpayDetails() async {
    final response = await _helper.get("/getRozarpayKey");
    RazorpayDetailsModel razorpayDetailsModel =
        RazorpayDetailResponse.fromJson(response).razorpayDetailsModel;
    return razorpayDetailsModel;
  }

  Future<ForgotPassowrdModel> verifyMobileAndSendOtp(
      String mobile, int otp) async {
    dynamic body = {'mobile': mobile, 'otp': otp.toString()};
    final response = await _helper.post("/validateMobileAndSendOtp", body);
    ForgotPassowrdModel forgotPassowrdModel =
        ForgotPasswordResponse.fromJson(response).forgotPassowrdModel;
    return forgotPassowrdModel;
  }

  Future<ForgotPassowrdModel> updatePassword(
      String password, String mobile) async {
    print('updatePassword : mobile : ${mobile} , password : ${password}');
    dynamic body = {'mobile': mobile, 'password': password};
    final response = await _helper.post("/resetPasswords", body);
    ForgotPassowrdModel forgotPassowrdModel =
        ForgotPasswordResponse.fromJson(response).forgotPassowrdModel;
    return forgotPassowrdModel;
  }

  Future<ForgotPassowrdModel> updateProfile(
      int userId,
      String name,
      String email,
      String mobile,
      String oldPassword,
      String newPassword,
      String base64Image) async {
    dynamic body = {
      'userId': userId.toString(),
      'email': email,
      'mobile': mobile,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'name': name,
      'base64Image': base64Image
    };

    final response = await _helper.post("/updateProfile", body);
    ForgotPassowrdModel forgotPassowrdModel =
        ForgotPasswordResponse.fromJson(response).forgotPassowrdModel;
    return forgotPassowrdModel;
  }

  Future<CouponApplyModel> validateCoupon(
      String couponCode, int userId, double totalAmount) async {
    dynamic body = {
      'couponCode': couponCode,
      'userId': userId.toString(),
      'totalAmount': totalAmount.toString()
    };

    final response = await _helper.post("/valiDateCouponDetail", body);
    CouponApplyModel couponApplyModel =
        CouponApplyModelResponse.fromJson(response).couponApplyModel;
    return couponApplyModel;
  }

  Future<NotificationResponseModel> getNotification(String userId) async {
    final response = await _helper.get("/getNotification?userId=$userId");
    NotificationResponseModel notificationResponseModel =
        NotificationResponse.fromJson(response).notificationResponseModel;
    return notificationResponseModel;
  }
  
}
