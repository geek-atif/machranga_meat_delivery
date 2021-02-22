import '../widgets/my_button.dart';
import '../repository/user_detail_respository.dart';
import '../util/constant.dart';
import '../util/loading.dart';
import '../util/styling.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class RestPasswordScreen extends StatefulWidget {
  @override
  _RestPasswordScreenState createState() => _RestPasswordScreenState();
}

class _RestPasswordScreenState extends State<RestPasswordScreen> {
  final GlobalKey<FormState> _formKeyNew = GlobalKey();
  String password = '';
  String mobile = '';
  var _isLoadingFor = false;
  var scaffoldKey = new GlobalKey<ScaffoldState>();

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

    UserDetailRespository()
        .updatePassword(password, mobile)
        .then((forgotPassowrdModel) {
      if (forgotPassowrdModel.errorStatus) {
        FocusScope.of(context).unfocus();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              forgotPassowrdModel.message,
              style: TextStyle(color: AppTheme.redButtonColor),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          Constant.LOGIN_ROUTE_NAME,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mobile = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: 'Reset Password',
      ),
      body: Container(
        child: Form(
          key: _formKeyNew,
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 15,
                right: 15,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    autofocus: true,
                    keyboardType:
                        TextInputType.text, // Use email input type for emails.
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password should not be empty';
                      }
                    },
                    onSaved: (value) {
                      print('value : ${value}');
                      password = value;
                    },
                  ),
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
                          buttonText: 'RESET PASSWORD',
                          buttonColor: AppTheme.redButtonColor,
                          textColor: Colors.white,
                        ),
                      ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
