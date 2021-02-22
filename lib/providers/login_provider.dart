import 'dart:async';
import 'package:Machranga/util/sharedpreferences_constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_model.dart';
import 'package:flutter/material.dart';
import '../repository/login_repository.dart';

class LoginProvider with ChangeNotifier {
  LoginRepository _loginRepository;
  LoginProvider() {
    _loginRepository = new LoginRepository();
  }

  Future<LoginModel> login(
      String mobile, String password, String firebaseId) async {
    try {
      final storage = FlutterSecureStorage();
      LoginModel loginResponse =
          await _loginRepository.login(mobile, password, firebaseId);
      if (loginResponse.errorStatus) {
        return loginResponse;
      }

      final prefs = await SharedPreferences.getInstance();
      print('${loginResponse.loginData.userId}');
      prefs.setInt(
          SharedpreferencesConstant.userId, loginResponse.loginData.userId);
      // prefs.setString(SharedpreferencesConstant.email, email);
      // prefs.setString(SharedpreferencesConstant.userName, loginResponse.loginData.userName);
      // prefs.setString(SharedpreferencesConstant.userMobile, loginResponse.loginData.userPhone);
      // prefs.setString(SharedpreferencesConstant.userImage, loginResponse.loginData.userImage);
      prefs.setBool(SharedpreferencesConstant.isLogin, true);
      storage.write(
          key: SharedpreferencesConstant.jwt,
          value: loginResponse.loginData.jwtToken);
      notifyListeners();
      return loginResponse;
    } catch (ex) {
      print('Ex: $ex');
      LoginModel loginModel = LoginModel();
      loginModel.errorStatus = true;
      loginModel.message = ex.toString();
      return loginModel;
    }
  }
}
