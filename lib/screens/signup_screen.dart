import 'dart:math';

import '../providers/signup_provider.dart';
import '../util/loading.dart';
import '../util/styling.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/my_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/constant.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isCheckedTerm = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'mobileNo': '',
    'isChecked': '',
  };
  var _isLoading = false;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  var _firebaseId;

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    if (!isCheckedTerm) {
      FocusScope.of(context).unfocus();
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Please check Terms and conditions',
            style: TextStyle(color: AppTheme.redButtonColor),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var otp = min + randomizer.nextInt(max - min);

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    print('_SignupScreenState  firebase_id :  ${_firebaseId}');
    await Provider.of<SignupProvider>(context, listen: false)
        .signup(
      _authData['email'],
      _authData['password'],
      _authData['mobileNo'],
      _authData['name'],
      otp,
      _firebaseId,
    )
        .then((signupModel) {
      setState(() {
        _isLoading = false;
      });
      if (signupModel.errorStatus) {
        FocusScope.of(context).unfocus();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              signupModel.message,
              style: TextStyle(color: AppTheme.redButtonColor),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          Constant.OTP_ROUTE_NAME,
          arguments: [otp, signupModel.userId],
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfirebaseId();
  }

  void getfirebaseId() {
    _messaging.getToken().then((token) {
      _firebaseId = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(
        title: 'SIGN UP',
      ),
      body: Container(
          padding: EdgeInsets.only(right: 15.0, left: 15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  keyboardType:
                      TextInputType.text, // Use email input type for emails.
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Name!';
                    }
                  },
                  onSaved: (String value) {
                    _authData['name'] = value;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                TextFormField(
                  maxLength: 10,
                  keyboardType:
                      TextInputType.number, // Use email input type for emails.
                  decoration: InputDecoration(labelText: 'Mobile No'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Mobile No!';
                    }
                    if (value.length < 10) {
                      return 'Enter 10 digit mobile no!';
                    }
                  },
                  onSaved: (String value) {
                    _authData['mobileNo'] = value;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                TextFormField(
                  keyboardType: TextInputType
                      .emailAddress, // Use email input type for emails.
                  decoration: InputDecoration(
                      hintText: 'you@example.com', labelText: 'E-mail Address'),
                  validator: (value) {
                    if (value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.com')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (String value) {
                    _authData['email'] = value;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                TextFormField(
                  obscureText: true, // Use secure text for passwords.
                  decoration: InputDecoration(
                      hintText: 'Password', labelText: 'Enter your password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (String value) {
                    _authData['password'] = value;
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
                              if (!isCheckedTerm) {
                                FocusScope.of(context).unfocus();
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please check Terms and conditions',
                                      style: TextStyle(
                                          color: AppTheme.redButtonColor),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.01),
                    Text(
                      'Agree to all terms and conditions',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.05,
                ),
                if (_isLoading)
                  Loading(
                    loadingMessage: '',
                  )
                else
                  GestureDetector(
                    onTap: () {
                      _submit();
                    },
                    child: MyButton(
                      buttonText: 'SIGN UP',
                      buttonColor: AppTheme.redButtonColor,
                      textColor: Colors.white,
                    ),
                  ),
                // Container(
                //   width: screenSize.width,
                //   child: RaisedButton(
                //     padding: EdgeInsets.all(15.0),
                //     elevation: 1,
                //     child: Text(
                //       'SIGN UP',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     onPressed: _submit,
                //     color: AppTheme.redButtonColor,
                //   ),
                //   margin: EdgeInsets.only(top: 20.0),
                // ),
                SizedBox(height: screenSize.height * 0.015),
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B6B6B),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.01),
                GestureDetector(
                  onTap: () {
                    print('Login clicked');
                    Navigator.of(context)
                        .pushReplacementNamed(Constant.LOGIN_ROUTE_NAME);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFDD2121),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
