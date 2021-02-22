import 'dart:convert';
import 'dart:io';
import '../util/my_singleton.dart';
import '../util/util_function.dart';
import '../providers/user_detail_provider.dart';
import '../util/constant.dart';
import '../widgets/my_button.dart';
import 'package:provider/provider.dart';
import '../models/user_deatil_model.dart';
import '../util/images.dart';
import '../util/loading.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/styling.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  Map<String, String> _authData = {
    'email': '',
    'name': '',
    'mobileNo': '',
    'oldPassword': '',
    'newPassword': ''
  };

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var mobileNoController = TextEditingController();
  var userDetailModel;

  String base64Image = '';
  Future<PickedFile> file;
  File fileM;
  var _isLoading = false;
  final GlobalKey<FormState> _formKeyNew = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('didChangeDependencies() called');
  }

  Future<void> _submitResetPassword() async {
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
      return;
    }
    if (!_formKeyNew.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKeyNew.currentState.save();

    setState(() {
      _isLoading = true;
    });

    await SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);

      Provider.of<UserDetailProvider>(context, listen: false)
          .updateProfile(
              userID,
              _authData['name'],
              _authData['email'],
              _authData['mobileNo'],
              _authData['oldPassword'],
              _authData['newPassword'],
              base64Image)
          .then((forgotPassowrdModel) {
        if (forgotPassowrdModel.errorStatus) {
          setState(() {
            _isLoading = false;
          });
          UtilFunction().showToast(forgotPassowrdModel.message);
          return;
        }

        FocusScope.of(context).unfocus();
        MySingleton.shared.utilFunction
            .showToastGreen(forgotPassowrdModel.message);
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacementNamed(
            Constant.BOTTOM_NAVIGATION_NAME,
            arguments: 3);
      });
    });
  }

  File imageURI;

  Future _choose() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    base64Image = base64Encode(image.readAsBytesSync());
    setState(() {
      imageURI = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    userDetailModel =
        ModalRoute.of(context).settings.arguments as UserDeatilModel;

    if (userDetailModel != null) {
      emailController.text = userDetailModel.userDeatil.email;
      nameController.text = userDetailModel.userDeatil.name;
      mobileNoController.text = userDetailModel.userDeatil.mobile;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(
        title: 'EDIT PROFILE',
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            height: screenSize.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _choose();
                  },
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    child: userDetailModel.userDeatil.imageUrl.isEmpty
                        ? imageURI == null
                            ? Container(
                                child: Image.asset(
                                  Images.profileImage,
                                ),
                              )
                            : Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: FileImage(imageURI),
                                  ),
                                ),
                              )
                        : imageURI != null
                            ? Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: FileImage(imageURI),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: NetworkImage(
                                      userDetailModel.userDeatil.imageUrl,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                SizedBox(height: screenSize.height * 0.01),
                Container(
                  margin: EdgeInsets.only(right: 40, left: 40),
                  child: Form(
                    key: _formKeyNew,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          initialValue: nameController.text,
                          autofocus: true,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Name!';
                            }
                          },
                          onSaved: (String value) {
                            _authData['name'] = value;
                            print('${_authData['name']}');
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name',
                            // prefixIcon: Padding(
                            //   padding: const EdgeInsets.all(0.0),
                            //   child: Image.asset(
                            //     Images.userIcon,

                            //   ),
                            // ),
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        TextFormField(
                          initialValue: emailController.text,
                          keyboardType: TextInputType
                              .emailAddress, // Use email input type for emails.
                          decoration: InputDecoration(
                            hintText: 'Enter Your email',
                            // prefixIcon: Image.asset(
                            //   Images.emailIcon,

                            // ),
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
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
                        SizedBox(height: screenSize.height * 0.01),
                        TextFormField(
                          initialValue: mobileNoController.text,
                          keyboardType: TextInputType
                              .phone, // Use email input type for emails.
                          decoration: InputDecoration(
                            hintText: 'Enter Your Mobile',
                            // prefixIcon: Image.asset(
                            //   Images.phoneIcon,
                            //   height: 5,
                            //   width: 5,
                            // ),
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
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
                        SizedBox(
                          height: screenSize.height * 0.02,
                        ),
                        Text(
                          'Change password',
                          style: TextStyle(
                              fontFamily: 'Galano Grotesque', fontSize: 16),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.02,
                        ),
                        TextFormField(
                          keyboardType: TextInputType
                              .visiblePassword, // Use email input type for emails.
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                            // prefixIcon: Image.asset(
                            //   Images.phoneIcon,
                            //   height: 5,
                            //   width: 5,
                            // ),
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          onSaved: (String value) {
                            _authData['oldPassword'] = value;
                          },
                        ),
                        SizedBox(
                          height: screenSize.height * 0.01,
                        ),
                        TextFormField(
                          keyboardType: TextInputType
                              .visiblePassword, // Use email input type for emails.
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            // prefixIcon: Image.asset(
                            //   Images.phoneIcon,
                            //   height: 5,
                            //   width: 5,
                            // ),
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),

                          onSaved: (String value) {
                            _authData['newPassword'] = value;
                          },
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        if (_isLoading)
                          Loading(
                            loadingMessage: '',
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              _submitResetPassword();
                            },
                            child: MyButton(
                              buttonText: 'UPDATE PROFILE',
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
                        //       'UPDATE PROFILE',
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //     onPressed: _submitResetPassword,
                        //     color: AppTheme.redButtonColor,
                        //   ),
                        //   margin: EdgeInsets.only(top: 20.0),
                        // ),
                      ],
                    ),
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
