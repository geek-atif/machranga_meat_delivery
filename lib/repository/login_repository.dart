import 'package:Machranga/response/login_response.dart';
import '../models/login_model.dart';
import '../api_base_helper/api_base_helper.dart';

class LoginRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginModel> login(
      String mobile, String password, String firebaseId) async {
    dynamic body = {
      'mobile': mobile,
      'password': password,
      'firebaseId': firebaseId,
    };

    final response = await _helper.post("/login", body);
    LoginModel loginModel = LoginResponse.fromJson(response).loginModel;
    return loginModel;
  }
}
