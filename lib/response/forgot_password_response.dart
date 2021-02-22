import '../models/forgot_password_model.dart';

class ForgotPasswordResponse {
  ForgotPassowrdModel forgotPassowrdModel;
  ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    forgotPassowrdModel = ForgotPassowrdModel();
    forgotPassowrdModel.errorStatus = json['errorStatus'];
    forgotPassowrdModel.message = json['message'];
  }
}
