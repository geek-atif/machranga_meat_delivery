import '../util/constant.dart';
import '../widgets/my_button.dart';
import '../providers/signup_provider.dart';
import '../util/loading.dart';
import '../util/styling.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OtpScreenForgetPassword extends StatefulWidget {
  @override
  _OtpScreenForgetPasswordState createState() =>
      _OtpScreenForgetPasswordState();
}

class _OtpScreenForgetPasswordState extends State<OtpScreenForgetPassword>
    with CodeAutoFill {
  final _formKey = GlobalKey<FormState>();
  var devOTp;
  var mobile;
  String otpCode;

  @override
  void initState() {
    super.initState();
    // SmsAutoFill().getAppSignature.then((signature) {
    //   print('############################################## signature $signature' ); 
    // });
    listenOtp();
  }

  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isLoading = false;

  void listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    super.dispose();
    SmsAutoFill().unregisterListener();
    cancel();
  }

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
    });
  }

  Future<void> _submit() async {
    if (devOTp.toString() != otpCode.toString()) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect OTP',
            style: TextStyle(color: AppTheme.redButtonColor),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    _formKey.currentState.save();

    Navigator.of(context).pushReplacementNamed(
        Constant.RESET_PASSWORD_ROUTE_NAME,
        arguments: mobile);
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments as List;
    if (data != null) {
      devOTp = data[0];
      mobile = data[1];
    }
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(
        title: 'ENTER OTP',
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                PinFieldAutoFill(
                  autofocus: true,
                  codeLength: 6,
                  currentCode: otpCode,
                  onCodeChanged: (val) {
                    if (val.length == 6) {
                      otpCode = val;
                    }
                  },
                  decoration: UnderlineDecoration(
                    color: Colors.black,
                    textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                // TextFormField(
                //     keyboardType: TextInputType.number,
                //     decoration: InputDecoration(
                //       labelText: 'Enter OTP',
                //     ),
                //     // validator: _validateEmail,
                //     onSaved: (String value) {
                //       _otpData.otp = value;
                //     }),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  'We have sent an an OTP to your mobile no',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B6B6B),
                  ),
                  //textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.02),
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
                      buttonText: 'SUBMIT',
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
                //       'SUBMIT',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     onPressed: _submit,
                //     color: AppTheme.redButtonColor,
                //   ),
                //   margin: EdgeInsets.only(top: 20.0),
                // ),
              ],
            ),
          )),
    );
  }
}
