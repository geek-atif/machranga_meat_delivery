import '../models/pinCodeModel.dart';

class PinCodeResponse {
  PinCodeModel pinCodeModel;
  PinCodeResponse.fromJson(Map<String, dynamic> json) {
    pinCodeModel = PinCodeModel();
    pinCodeModel.errorStatus = json['errorStatus'];
    pinCodeModel.message = json['message'];
  }
}
