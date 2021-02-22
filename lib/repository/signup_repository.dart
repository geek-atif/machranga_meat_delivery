import '../models/addres_response_model.dart';
import '../models/signup_model.dart';
import '../response/address_response.dart';
import '../response/signup_response.dart';
import '../api_base_helper/api_base_helper.dart';

class SignupRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SignupModel> signup(String email, String password, String mobile,
      String name, int otp, String firebaseId) async {
    dynamic body = {
      'email': email,
      'password': password,
      'name': name,
      'mobile_no': mobile,
      'firebase_id': firebaseId,
      'otp': otp.toString(),
    };

    final response = await _helper.post("/registration", body);
    SignupModel signupModel = SignupResponse.fromJson(response).signupModel;
    print(signupModel.errorStatus);
    return signupModel;
  }

  Future<SignupModel> otp(int userId) async {
    dynamic body = {
      'userId': userId.toString(),
    };

    final response = await _helper.post("/userStatusUpdate", body);

    SignupModel signupModel = SignupResponse.fromJson(response).signupModel;
    print(signupModel.errorStatus);
    return signupModel;
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
    dynamic body = {
      'userId': userId.toString(),
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'pinCode': pinCode,
      'state': state,
      'landMark': landMark,
      'mobileNo': mobileNo,
      'isDefault': isDefault,
    };

    final response = await _helper.post("/addAddress", body);
    print('response ${response}');
    AddressResponseModel signupModel =
        AddressResponse.fromJson(response).addressResponseModel;
    return signupModel;
  }

  Future<AddressResponseModel> getALLAddress(int userId) async {
    final response = await _helper.get("/getUserAddress?userId=$userId");
    AddressResponseModel signupModel =
        AddressResponse.fromJsonAll(response).addressResponseModel;
    return signupModel;
  }

  Future<AddressResponseModel> updateAdress(
      String addressData1,
      String addressData2,
      String pinCode,
      String state,
      String mobileNo,
      String landMark,
      int userId,
      String addressId) async {
    dynamic body = {
      'userId': userId.toString(),
      'addressLine1': addressData1,
      'addressLine2': addressData2,
      'pinCode': pinCode,
      'state': state,
      'landMark': landMark,
      'mobileNo': mobileNo,
      'addressId': addressId
    };

    final response = await _helper.post("/updateAddress", body);
    AddressResponseModel signupModel =
        AddressResponse.fromJson(response).addressResponseModel;
    return signupModel;
  }
  
}
