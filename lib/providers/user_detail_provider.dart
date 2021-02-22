import 'dart:async';
import '../models/notification_response_model.dart';
import '../models/coupon_apply_model.dart';
import '../models/forgot_password_model.dart';
import '../models/pinCodeModel.dart';
import '../models/user_deatil_model.dart';
import '../repository/user_detail_respository.dart';
import 'package:flutter/material.dart';

class UserDetailProvider with ChangeNotifier {
  UserDetailRespository _userDetailRespository;
  UserDetailProvider() {
    _userDetailRespository = new UserDetailRespository();
  }

  Future<UserDeatilModel> getUserDetail(int userId) async {
    try {
      UserDeatilModel userDeatilModel =
          await _userDetailRespository.getUserDetail(userId);
      return userDeatilModel;
    } catch (ex) {
      print('Ex: $ex');
      UserDeatilModel productListModel = UserDeatilModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<ForgotPassowrdModel> updateProfile(
      int userID,
      String name,
      String email,
      String mobileNo,
      String oldPassword,
      String newPassword,
      String base64image) async {
    try {
      ForgotPassowrdModel forgotPassowrdModel =
          await _userDetailRespository.updateProfile(userID, name, email,
              mobileNo, oldPassword, newPassword, base64image);

      return forgotPassowrdModel;
    } catch (ex) {
      print('Ex: $ex');
      ForgotPassowrdModel productListModel = ForgotPassowrdModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<PinCodeModel> getPinDetails(String pinCodeToSend) async {
    try {
      PinCodeModel pinCodeModel =
          await _userDetailRespository.getPinDetails(pinCodeToSend);
      return pinCodeModel;
    } catch (ex) {
      print('Ex: $ex');
      PinCodeModel productListModel = PinCodeModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<CouponApplyModel> validateCoupon(
      String couponCode, int userId, double totalAmount) async {
    try {
      CouponApplyModel couponApplyModel = await _userDetailRespository
          .validateCoupon(couponCode, userId, totalAmount);
      return couponApplyModel;
    } catch (ex) {
      print('Ex: $ex');
      CouponApplyModel productListModel = CouponApplyModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<NotificationResponseModel> getNotification(int userId) async {
    try {
      NotificationResponseModel notificationResponseModel =
          await _userDetailRespository.getNotification(userId.toString());
      return notificationResponseModel;
    } catch (ex) {
      print('Ex: $ex');
      NotificationResponseModel productListModel = NotificationResponseModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }
}
