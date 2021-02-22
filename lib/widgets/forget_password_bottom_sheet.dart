import 'dart:math';
import '../util/my_singleton.dart';
import '../widgets/my_button.dart';
import '../util/constant.dart';
import '../repository/user_detail_respository.dart';
import '../util/loading.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';
class ForgetPasswordBottomSheet extends StatefulWidget {
  const ForgetPasswordBottomSheet({
    Key key,
    @required this.context,
    @required this.scaffoldKey,
  }) : super(key: key);

  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ForgetPasswordBottomSheetState createState() =>
      _ForgetPasswordBottomSheetState(
          scaffoldKey: scaffoldKey, context: context);
}

class _ForgetPasswordBottomSheetState extends State<ForgetPasswordBottomSheet> {
  final BuildContext context;
  final GlobalKey<FormState> _formKeyNew = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey;

  _ForgetPasswordBottomSheetState({
    @required this.context,
    @required this.scaffoldKey,
  });

  String mobileNumber = '';
  var _isLoadingFor = false;

  Future<void> _submitResetPassword() async {
    print('_submitResetPassword');
    if (!_formKeyNew.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKeyNew.currentState.save();

    setState(() {
      _isLoadingFor = true;
    });

    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var otp = min + randomizer.nextInt(max - min);

    UserDetailRespository()
        .verifyMobileAndSendOtp(mobileNumber, otp)
        .then((forgotPassowrdModel) {
      if (forgotPassowrdModel.errorStatus) {
        setState(() {
          _isLoadingFor = false;
        });
        FocusScope.of(context).unfocus();
        MySingleton.shared.utilFunction.showToast(forgotPassowrdModel.message);
      } else {
        Navigator.of(context).pushReplacementNamed(
          Constant.OTP_FORGOT_PASSWORD_ROUTE_NAME,
          arguments: [otp, mobileNumber],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SingleChildScrollView(
       // child: Card(
        //  elevation: 5,
          child: Form(
            key: _formKeyNew,
            child: Container(
              padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Forgot Passowrd',
                    style: TextStyle(
                      fontFamily: 'Galano Grotesque',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLength: 10,
                    autofocus: true,
                    keyboardType: TextInputType
                        .number, // Use email input type for emails.
                    decoration: InputDecoration(
                      labelText: 'Mobile No',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Mobile Number should not be empty';
                      }
                      if (value.length < 10) {
                        return 'Enter 10 digit mobile';
                      }
                    },
                    onSaved: (value) {
                      print('value : ${value}');
                      mobileNumber = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _isLoadingFor
                      ? Loading(
                          loadingMessage: '',
                        )
                      : GestureDetector(
                          onTap: () {
                            _submitResetPassword();
                          },
                          child: MyButton(
                            buttonText: 'GET OTP',
                            buttonColor: AppTheme.redButtonColor,
                            textColor: Colors.white,
                          ),
                        ),
                  // : Container(
                  //     margin: EdgeInsets.only(right: 50, left: 50),
                  //     width: double.infinity,
                  //     alignment: Alignment.center,
                  //     child: RaisedButton(
                  //       color: AppTheme.redButtonColor,
                  //       child: Text('GET OTP'),
                  //       textColor: Colors.white,
                  //       onPressed: () {
                  //         _submitResetPassword();
                  //       },
                  //     ),
                  //   ),
                  SizedBox(
                    height: 130,
                  ),
                ],
              ),
            ),
          ),
       // ),
      ),
      behavior: HitTestBehavior.opaque,
    );
  }
}
