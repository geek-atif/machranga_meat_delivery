import 'dart:async';
import '../models/addres_response_model.dart';
import '../models/signup_model.dart';
import '../repository/signup_repository.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  SignupRepository _signupRepository;
  SignupProvider() {
    _signupRepository = new SignupRepository();
  }

  Future<SignupModel> signup(String email, String password, String mobile,
      String name, int otp, String firebaseId) async {
    try {
      final storage = FlutterSecureStorage();
      SignupModel signupResponse = await _signupRepository.signup(
          email, password, mobile, name, otp, firebaseId);

      if (signupResponse.errorStatus) {
        return signupResponse;
      }
      storage.write(
          key: SharedpreferencesConstant.jwt, value: signupResponse.jwt);

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(SharedpreferencesConstant.userId, signupResponse.userId);
      // prefs.setString(SharedpreferencesConstant.email, email);
      // prefs.setString(SharedpreferencesConstant.userName, name);
      // prefs.setString(SharedpreferencesConstant.userMobile, mobile);
      notifyListeners();

      return signupResponse;
    } catch (ex) {
      print('Ex: $ex');
      SignupModel productListModel = SignupModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<SignupModel> otp(int userId) async {
    try {
      SignupModel signupResponse = await _signupRepository.otp(userId);
      if (signupResponse.errorStatus) {
        return signupResponse;
      }

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(SharedpreferencesConstant.isLogin, true);
      notifyListeners();
      return signupResponse;
    } catch (ex) {
      print('Ex: $ex');
      SignupModel productListModel = SignupModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<AddressResponseModel> addAddress(
      String addressLine1,
      String addressLine2,
      String pinCode,
      String state,
      String mobileNo,
      String landMark,
      int userId,
      String isDefault) async {
    try {
      AddressResponseModel addressResponseModel =
          await _signupRepository.addAddress(addressLine1, addressLine2,
              pinCode, state, mobileNo, landMark, userId, isDefault);

      notifyListeners();
      return addressResponseModel;
    } catch (ex) {
      print('Ex: $ex');
      AddressResponseModel productListModel = AddressResponseModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }

    // AddressModel addressModel = AddressModel(
    //     addressId: addressResponseModel.addressModel.addressId,
    //     addressLine1: addressLine1,
    //     userId: userId,
    //     state:state,
    //     pinCode: pinCode,
    //     mobileNo: mobileNo,
    //     isDefault: isDefault,
    //     landMark: landMark,
    //     addressLine2: addressLine2, );

    //String addressModelStr = jsonEncode(addressModel);
    //print('addressModelStr : ${addressModelStr}');

    // final prefs = await SharedPreferences.getInstance();
    // var addressOneStr = prefs.getString(SharedpreferencesConstant.addressOne);
    // var addressTwoStr = prefs.getString(SharedpreferencesConstant.addressTwo);
    // var addressThreeStr =
    //     prefs.getString(SharedpreferencesConstant.addressThree);

    // if (addressOneStr == null) {
    //   prefs.setString(SharedpreferencesConstant.addressOne, addressModelStr);
    //   notifyListeners();
    //   return addressResponseModel;
    // }

    // if (addressTwoStr == null) {
    //   prefs.setString(SharedpreferencesConstant.addressTwo, addressModelStr);
    //   notifyListeners();
    //   return addressResponseModel;
    // }

    // if (addressThreeStr == null) {
    //   prefs.setString(SharedpreferencesConstant.addressThree, addressModelStr);
    //   notifyListeners();
    //   return addressResponseModel;
    // }
  }

  Future<AddressResponseModel> getAllAddress(int userId) async {
    try {
      AddressResponseModel addressResponseModel =
          await _signupRepository.getALLAddress(userId);

      notifyListeners();
      return addressResponseModel;
    } catch (ex) {
      print('Ex: $ex');
      AddressResponseModel productListModel = AddressResponseModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<AddressResponseModel> updateAddress(
      String addressData1,
      String addressData2,
      String pinCode,
      String state,
      String mobileNo,
      String landMark,
      int userId,
      String addressId) async {
    try {
      AddressResponseModel addressResponseModel =
          await _signupRepository.updateAdress(addressData1, addressData2,
              pinCode, state, mobileNo, landMark, userId, addressId);

      notifyListeners();
      return addressResponseModel;
    } catch (ex) {
      print('Ex: $ex');
      AddressResponseModel productListModel = AddressResponseModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }
}
