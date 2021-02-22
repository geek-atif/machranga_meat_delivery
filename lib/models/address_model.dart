class AddressModel {
  String addressLine1;
  String addressLine2 = '';
  String pinCode;
  String state;
  String mobileNo;
  int userId;
  String landMark;
  String isDefault = '0';
  String addressId;

  AddressModel({
    this.addressLine1,
    this.addressLine2,
    this.pinCode,
    this.state,
    this.mobileNo,
    this.userId,
    this.isDefault,
    this.landMark,
    this.addressId,
  });

  Map toJson() => {
        'addressId': addressId,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'pinCode': pinCode,
        'state': state,
        'mobileNo': mobileNo,
        'userId': userId,
        'isDefault': isDefault,
        'landMark': landMark,
      };

  static AddressModel getAddressModel(v) {
    AddressModel addressModel = new AddressModel();
    addressModel.addressId = v['addressId'];
    addressModel.addressLine1 = v['addressLine1'];
    addressModel.isDefault = v['isDefault'];
    return addressModel;
  }
}
