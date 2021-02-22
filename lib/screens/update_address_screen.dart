import 'dart:async';
import '../util/util_function.dart';
import '../models/address_model.dart';
import '../providers/signup_provider.dart';
import '../util/constant.dart';
import '../util/loading.dart';
import '../util/sharedpreferences_constant.dart';
import '../util/styling.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAddressScreen extends StatefulWidget {
  @override
  _UpdateAddressScreenState createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isCheckedTerm = false;
  int userId = 0;
  AddressModel addressModel;
  var addressLine1Controller = TextEditingController();
  var addressLine2Controller = TextEditingController();
  var pinCodeController = TextEditingController();
  var stateController = TextEditingController();
  var mobileNoController = TextEditingController();
  var landMarkController = TextEditingController();

  Map<String, String> _addressData = {
    'addressLine1': '',
    'addressLine2': '',
    'pinCode': '',
    'state': '',
    'mobileNo': '',
    'landMark': '',
  };
  var _isLoading = false;
  var addressId;
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then(
      (prefs) {
        mobileNoController.text =
            prefs.getString(SharedpreferencesConstant.userMobile);
        userId = prefs.getInt(SharedpreferencesConstant.userId);
      },
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  //Position _location = Position(latitude: 0.0, longitude: 0.0);
  void _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(location.latitude, location.longitude);
    var geoCoderRst =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      addressLine1Controller.text = geoCoderRst.first.addressLine;
      pinCodeController.text = geoCoderRst.first.postalCode;
      stateController.text = geoCoderRst.first.adminArea;
    });
  }

  Future<void> _submit() async {
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }

    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    await Provider.of<SignupProvider>(context, listen: false)
        .updateAddress(
            _addressData['addressLine1'],
            _addressData['addressLine2'],
            _addressData['pinCode'],
            _addressData['state'],
            _addressData['mobileNo'],
            _addressData['landMark'],
            userId,
            addressModel.addressId)
        .then((signupModel) {
      setState(() {
        _isLoading = false;
      });
      if (signupModel.errorStatus) {
        FocusScope.of(context).unfocus();
        UtilFunction().showToast(signupModel.message);
        
      } else {
        Navigator.of(context).pushReplacementNamed(Constant.ADDRESS_ROUTE_NAME);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    addressModel = ModalRoute.of(context).settings.arguments as AddressModel;

    addressLine1Controller.text = addressModel.addressLine1;
    addressLine2Controller.text = addressModel.addressLine2;
    pinCodeController.text = addressModel.pinCode;
    stateController.text = addressModel.state;
    mobileNoController.text = addressModel.mobileNo;
    landMarkController.text = addressModel.landMark;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(
        title: 'UPDATE ADDRESS',
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType
                          .text, // Use email input type for emails.
                      decoration: InputDecoration(labelText: 'Address line 1'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Address line 1!';
                        }
                      },
                      onSaved: (String value) {
                        _addressData['addressLine1'] = value;
                      },

                      initialValue: addressLine1Controller.text,
                    ),
                    Positioned(
                      bottom: 35,
                      right: 3,
                      child: GestureDetector(
                        onTap: () {
                          _displayCurrentLocation();
                        },
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/loction.png',
                              height: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Detect my location',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFFDD2121)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                //controller: addressLine2Controller,
                autofocus: true,
                keyboardType:
                    TextInputType.text, // Use email input type for emails.
                decoration: InputDecoration(labelText: 'Address line 2'),
                onSaved: (String value) {
                  _addressData['addressLine2'] = value;
                },
              ),
              TextFormField(
                initialValue: landMarkController.text,
                autofocus: true,
                keyboardType:
                    TextInputType.text, // Use email input type for emails.
                decoration: InputDecoration(labelText: 'Land Mark'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Lank Mark!';
                  }
                },
                onSaved: (String value) {
                  _addressData['landMark'] = value;
                },
              ),
              TextFormField(
                keyboardType:
                    TextInputType.number, // Use email input type for emails.
                decoration: InputDecoration(labelText: 'Mobile No'),
                maxLength: 10,
                initialValue: mobileNoController.text,
                onSaved: (String value) {
                  _addressData['mobileNo'] = value;
                },
              ),
              TextFormField(
                initialValue: pinCodeController.text,
                keyboardType:
                    TextInputType.number, // Use email input type for emails.
                decoration: InputDecoration(labelText: 'Pin Code'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Pin Code!';
                  }
                  if (value.length < 6) {
                    return 'Enter 6 digit pin code!';
                  }
                },
                maxLength: 6,
                onSaved: (String value) {
                  _addressData['pinCode'] = value;
                },
              ),
              TextFormField(
                initialValue: stateController.text,
                keyboardType:
                    TextInputType.text, // Use email input type for emails.
                decoration: InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter state!';
                  }
                },
                onSaved: (String value) {
                  _addressData['state'] = value;
                },
              ),
              SizedBox(height: screenSize.height * 0.02),
              if (_isLoading)
                Loading(
                  loadingMessage: '',
                )
              else
                Container(
                  width: screenSize.width,
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    elevation: 1,
                    child: Text(
                      'UPDATE ADDRESS',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _submit,
                    color: AppTheme.redButtonColor,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
