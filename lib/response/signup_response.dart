
import '../models/signup_model.dart';
class SignupResponse {
  SignupModel signupModel;
  SignupResponse.fromJson(Map<String, dynamic> json) {
    print('SignupResponse : ${json['errorStatus']}');
    //final storage = FlutterSecureStorage();
    signupModel = new SignupModel();
    signupModel.errorStatus = json['errorStatus'];
    signupModel.message = json['message'];
    if (json['data'] != '') {
      signupModel.userId = json['data'];
      signupModel.jwt = json['JWTKey'];
      
    }
  }
}
