import '../util/util_function.dart';
import '../models/address_model.dart';
import '../models/addres_response_model.dart';
import '../providers/signup_provider.dart';
import '../util/constant.dart';
import '../util/loading.dart';
import 'package:provider/provider.dart';
import '../util/sharedpreferences_constant.dart';
import '../util/styling.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int groupValue = -1;
  var _isLoading = false;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  int userId;
  AddressResponseModel addressResponseModel;
  // String addressOneStr = '';
  // String addressTwoStr = '';
  // String addressSelectedStr = '';
  // String addressThreeStr = '';
  // bool isAddToVisiable = true;

  // AddressModel addressModelOne;
  // AddressModel addressModelTwo;
  // AddressModel addressModelThree;

  void selectRadio(int value) {
    setState(() {
      groupValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  SharedPreferences prefs;

  @override
  void didChangeDependencies() {
    /*  setState(() {
     if (addressOneStr.isNotEmpty &&
          addressTwoStr.isNotEmpty &&
          addressThreeStr.isNotEmpty)
        isAddToVisiable = false;
      else
        isAddToVisiable = true;

      SharedPreferences.getInstance().then(
        (prefs) {
          addressOneStr = prefs.getString(SharedpreferencesConstant.addressOne);
          addressTwoStr = prefs.getString(SharedpreferencesConstant.addressTwo);
          addressThreeStr =
              prefs.getString(SharedpreferencesConstant.addressThree);

          if (addressOneStr != null) {
            addressModelOne =
                AddressModel.getAddressModel(jsonDecode(addressOneStr));
           
          }

          if (addressTwoStr != null) {
            addressModelTwo =
                AddressModel.getAddressModel(jsonDecode(addressTwoStr));
          }

          if (addressThreeStr != null) {
            addressModelThree =
                AddressModel.getAddressModel(jsonDecode(addressThreeStr));
          }
        },
      );
    });*/

    setState(() {
      _isLoading = true;
    });
    getUserId();
    super.didChangeDependencies();
  }

  getUserId() async {
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }

    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt(SharedpreferencesConstant.userId);
    Provider.of<SignupProvider>(context, listen: false)
        .getAllAddress(userId)
        .then((addressResponse) {
      // if (addressResponse.errorStatus) {
      //   UtilFunction().showToast(addressResponse.message);
      //   return;
      // }
      setState(() {
        _isLoading = false;
        addressResponseModel = addressResponse;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(
        title: 'ADDRESS',
      ),
      //  floatingActionButton: ProceedToCheckOutButtion(diliveryAmount: 0.0,),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              addAddressWidgets(screenSize),
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              if (_isLoading)
                Loading(loadingMessage: '')
              else
                listOfAddress(screenSize),
            ],
          ),
        ),
      ),
    );
  }

  Container listOfAddress(Size screenSize) {
    return addressResponseModel.addressModel == null
        ? Container()
        : Container(
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: addressResponseModel.addressModel.length,
              itemBuilder: (BuildContext context, int index) => addressOne(
                  screenSize, addressResponseModel.addressModel[index], index),
            ),
          );
  }

  Container addAddressWidgets(Size screenSize) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushReplacementNamed(Constant.ADD_ADDRESS_ROUTE_NAME);
        },
        child: Row(
          children: <Widget>[
            Container(
              width: screenSize.width * 0.8,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromRGBO(252, 233, 233, 1),
                  radius: 15,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: Icon(Icons.add, color: AppTheme.redButtonColor),
                    ),
                  ),
                ),
                title: Text(
                  'Add New Addresses',
                  style: TextStyle(
                      fontFamily: 'Muli', color: AppTheme.redButtonColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container addressOne(Size screenSize, AddressModel addressModel, int index) {
    return addressModel == null
        ? Container(child: Text('No Address'))
        : Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: index,
                  groupValue: groupValue,
                  activeColor: AppTheme.redButtonColor,
                  onChanged: (value) {
                    setState(() {
                      groupValue = value;
                      prefs.setString(SharedpreferencesConstant.selectedAddress,
                          '${addressModel.addressLine1} ${addressModel.addressLine2} ${addressModel.state} ${addressModel.pinCode}  ${addressModel.landMark} ${addressModel.mobileNo} ');
                      prefs.setString(
                          SharedpreferencesConstant.selectedAddressId,
                          addressModel.addressId);
                    });

                    Navigator.of(context).pushReplacementNamed(
                        Constant.ADDRESS_PAYMENT_ROUTE_NAME);
                  },
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: screenSize.width * 0.6,
                  child: Text(
                    '${addressModel.addressLine1} ${addressModel.addressLine2} ${addressModel.state} ${addressModel.pinCode}  ${addressModel.landMark} ${addressModel.mobileNo} ',
                    style: TextStyle(color: Colors.black, fontFamily: 'Muli'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        Constant.UPDATE_ADDRESS_ROUTE_NAME,
                        arguments: addressModel);
                  },
                  child: Container(
                    width: screenSize.width * 0.08,
                    margin: EdgeInsets.all(5),
                    child: const Icon(
                      Icons.edit,
                      size: 16.0,
                      color: AppTheme.redButtonColor,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  /*Container addressTwo(Size screenSize, String addressTwoStr) {
    return Container(
      width: screenSize.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 1,
            groupValue: groupValue,
            activeColor: AppTheme.redButtonColor,
            onChanged: selectRadio,
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: screenSize.width * 0.6,
            child: Text(
              addressModelTwo.addressLine1,
              style: TextStyle(color: Colors.black, fontFamily: 'Muli'),
            ),
          ),
          Container(
            width: screenSize.width * 0.08,
            margin: EdgeInsets.all(5),
            child: const Icon(
              Icons.edit,
              size: 16.0,
              color: AppTheme.redButtonColor,
            ),
          ),
        ],
      ),
    );
  }

  Container addressOne(Size screenSize, String addressOneStr) {
    return Container(
      width: screenSize.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 0,
            groupValue: groupValue,
            activeColor: AppTheme.redButtonColor,
            onChanged: selectRadio,
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: screenSize.width * 0.6,
            child: Text(
            addressModelOne.addressLine1,
              style: TextStyle(color: Colors.black, fontFamily: 'Muli'),
            ),
          ),
          Container(
            width: screenSize.width * 0.08,
            margin: EdgeInsets.all(5),
            child: const Icon(
              Icons.edit,
              size: 16.0,
              color: AppTheme.redButtonColor,
            ),
          ),
        ],
      ),
    );
  }*/

}
