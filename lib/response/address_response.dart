import '../models/addres_response_model.dart';
import '../models/address_model.dart';

class AddressResponse {
  AddressResponseModel addressResponseModel;
  AddressResponse.fromJson(Map<String, dynamic> json) {
    addressResponseModel = new AddressResponseModel();
    addressResponseModel.errorStatus = json['errorStatus'];
    addressResponseModel.message = json['message'];
  }

  AddressResponse.fromJsonAll(Map<String, dynamic> json) {
    addressResponseModel = new AddressResponseModel();
    addressResponseModel.errorStatus = json['errorStatus'];
    addressResponseModel.message = json['message'];
    if (json['data'] != '') {
      List<AddressModel> addressModel = new List<AddressModel>();
      json['data'].forEach(
        (v) {
          addressModel.add(parssData(v));
        },
      );
      addressResponseModel.addressModel = addressModel;
    }
  }

  AddressModel parssData(v) {
    AddressModel addressModel = new AddressModel();
    addressModel.addressLine1 = v['building_name'].toString();
    addressModel.addressLine2 = v['road_area_colony'].toString();
    addressModel.pinCode = v['pincode'].toString();
    addressModel.state = v['state'].toString();
    addressModel.mobileNo = v['mobile_no'].toString();
    addressModel.landMark = v['landmark'].toString();
    addressModel.isDefault = v['is_default'].toString();
    addressModel.addressId = v['id'].toString();
    return addressModel;
  }
}
