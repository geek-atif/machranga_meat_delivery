class LoginModel {
  bool errorStatus;
  String message;
  LoginData loginData;
}

class LoginData {
  int userId;
  String userName;
  String userPhone;
  String userImage;
  String jwtToken;
}
