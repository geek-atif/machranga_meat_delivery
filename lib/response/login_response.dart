import '../models/login_model.dart';
class LoginResponse {
  LoginModel loginModel;
  LoginResponse.fromJson(Map<String, dynamic> json) {
    loginModel = new LoginModel();
    loginModel.errorStatus = json['errorStatus'];
    loginModel.message = json['message'];
    if (json['data'] != '') {
      LoginData loginData = new LoginData();
      loginData.userId = json['data']['id'];
      loginData.userName = json['data']['user_name'];
      loginData.userPhone = json['data']['user_phone'].toString();
      loginData.userImage = json['data']['user_image'];
      loginData.jwtToken = json['data']['jwt_token'];
      loginModel.loginData = loginData;
     
    }
  }
  
}
