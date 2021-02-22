import 'dart:async';

import 'package:Machranga/widgets/my_rounded_loading_button.dart';

import '../screens/bottom_navigation_screen.dart';
import 'package:Machranga/widgets/slide_route.dart';

import '../widgets/forget_password_bottom_sheet.dart';
import '../widgets/my_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../util/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import '../widgets/my_app_bar.dart';
import '../util/styling.dart';
import '../util/loading.dart';
import '../util/constant_text.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var firebaseId;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;

  Map<String, String> _authData = {
    'mobile': '',
    'password': '',
  };
  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

   // animateButton();
    setState(() {
      _isLoading = true;
    });

    await Provider.of<LoginProvider>(context, listen: false)
        .login(_authData['mobile'], _authData['password'], firebaseId)
        .then((loginModel) {
      setState(() {
        _isLoading = false;
      });
      if (loginModel.errorStatus) {
        FocusScope.of(context).unfocus();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              loginModel.message,
              style: TextStyle(color: AppTheme.redButtonColor),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        Navigator.push(context, SlideLeftRoute(page: MyBottomNavScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfirebaseId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _btnController.stop();
    _controller.stop();
  }

  void getfirebaseId() {
    _messaging.getToken().then((token) {
      firebaseId = token;
    });
  }

  void _openResetBootomSheet(
      BuildContext ctx, GlobalKey<ScaffoldState> scaffoldKey) {
    print('_openResetBootomSheet() called');
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return ForgetPasswordBottomSheet(
          context: context,
          scaffoldKey: scaffoldKey,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(title: ConstantText.LOGIN_BUTTON),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                // onChanged: loginBloc.changeEmail,
                keyboardType:
                    TextInputType.number, // Use email input type for emails.
                decoration: InputDecoration(
                  labelText: 'Enter Mobile No',
                  // errorText: snapshot.error),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Mobile No';
                  }
                  if (value.length < 10) {
                    return 'Enter 10 digit mobile';
                  }
                },
                onSaved: (value) {
                  _authData['mobile'] = value;
                },
              ),
              SizedBox(height: screenSize.height * 0.02),
              TextFormField(
                //onChanged: loginBloc.changePassword,
                obscureText: true, // Use secure text for passwords.
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter your password',
                  //errorText: snapshot.error),
                ),

                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              SizedBox(height: screenSize.height * 0.02),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _openResetBootomSheet(context, scaffoldKey);
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Forgot Password?',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFA94545),
                    ),
                  ),
                ),
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
                    buttonText: ConstantText.LOGIN_BUTTON,
                    buttonColor: AppTheme.redButtonColor,
                    textColor: Colors.white,
                  ),
                ),

              // Container(
              //   key: _globalKey,
              //   width: _width,
              //   child: GestureDetector(
              //     onTap: () {
              //       _submit();
              //     },
              //     child: MyButton(
              //       buttonText: ConstantText.LOGIN_BUTTON,
              //       buttonColor: AppTheme.redButtonColor,
              //       textColor: Colors.white,
              //     ),
              //   ),
              // ),

              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Don’t have an account?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B6B6B),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenSize.height * 0.01),
              GestureDetector(
                onTap: () {
                  print('Signup clicked');
                  Navigator.of(context)
                      .pushReplacementNamed(Constant.SIGNUP_ROUTE_NAME);
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFDD2121),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });
      });
    _controller.forward();
  }
}
