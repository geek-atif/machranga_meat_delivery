import 'dart:async';
import '../util/util_function.dart';
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

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isCheckedTerm = false;
  int userId = 0;
  var addressLine1Controller = TextEditingController();
  var pinCodeController = TextEditingController();
  var stateController = TextEditingController();
  var mobileNoController = TextEditingController();

  Map<String, String> _addressData = {
    'addressLine1': '',
    'addressLine2': '',
    'pinCode': '',
    'state': '',
    'mobileNo': '',
    'landMark': '',
  };
  var _isLoading = false;
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
        .addAddress(
      _addressData['addressLine1'],
      _addressData['addressLine2'],
      _addressData['pinCode'],
      _addressData['state'],
      _addressData['mobileNo'],
      _addressData['landMark'],
      userId,
      isCheckedTerm ? '1' : '0',
    )
        .then((signupModel) {
      setState(() {
        _isLoading = false;
      });
      if (signupModel.errorStatus) {
        FocusScope.of(context).unfocus();
        print('signupModel ${signupModel.message}');
        UtilFunction().showToast(signupModel.message);
        // scaffoldKey.currentState.showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       signupModel.message,
        //       style: TextStyle(color: AppTheme.redButtonColor),
        //     ),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      } else {
        Navigator.of(context).pushReplacementNamed(Constant.ADDRESS_ROUTE_NAME);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(
        title: 'ADD ADDRESS',
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
                      controller: addressLine1Controller,
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
                autofocus: true,
                keyboardType:
                    TextInputType.text, // Use email input type for emails.
                decoration: InputDecoration(labelText: 'Address line 2'),
                onSaved: (String value) {
                  _addressData['addressLine2'] = value;
                },
              ),
              TextFormField(
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
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Enter Mobile No!';
                //   }
                //   if (value.length < 10) {
                //     return 'Enter 10 digit mobile no!';
                //   }
                // },
                controller: mobileNoController,
                onSaved: (String value) {
                  _addressData['mobileNo'] = value;
                },
              ),
              TextFormField(
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
                controller: pinCodeController,
                maxLength: 6,
                onSaved: (String value) {
                  _addressData['pinCode'] = value;
                },
              ),
              TextFormField(
                controller: stateController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        activeColor: AppTheme.redButtonColor,
                        value: isCheckedTerm,
                        onChanged: (value) {
                          print('onChanged');
                          setState(() {
                            isCheckedTerm = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.01),
                  Text(
                    'Set as default address',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
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
                      'ADD ADDRESS',
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
