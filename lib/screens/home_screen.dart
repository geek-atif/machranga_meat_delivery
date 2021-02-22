import 'dart:async';
import 'package:Machranga/screens/notification_screen.dart';
import 'package:Machranga/widgets/enter_exit_route.dart';
import 'package:Machranga/widgets/slide_route.dart';

import '../util/util_function.dart';
import '../util/constant.dart';
import '../util/my_singleton.dart';
import '../widgets/search_bar.dart';
import '../providers/user_detail_provider.dart';
import '../util/images.dart';
import '../widgets/my_button.dart';
import '../widgets/my_dialogs.dart';
import '../widgets/shimmer_home_screen.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/loading.dart';
import '../util/styling.dart';
import '../models/home_page_model.dart';
import '../providers/home_provider.dart';
import '../widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false;
  var _isInit = true;
  bool isVisable = false;
  HomePageModel _homePageModel = new HomePageModel();
  var pinCodeToDisplay;
  Map<String, String> _addressData = {
    'pinCode': '',
  };

  var _isLoadingNew = false;
  final _formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var pinCodeController = TextEditingController();
  int notificationCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('HomeScreen didChangeDependencies called');

    if (_isInit) {
      var isJWTValid = UtilFunction.isJWTValid().then((isJWTValid) {
        if (!isJWTValid) {
          UtilFunction.logout(context);
          return;
        }

        setState(() {
          _isLoading = true;
        });

        SharedPreferences.getInstance().then(
          (prefs) {
            pinCodeToDisplay =
                prefs.getString(SharedpreferencesConstant.pinCode);
            notificationCount =
                prefs.getInt(SharedpreferencesConstant.notificationCount);
            print('HomeScreen : notificationCount ${notificationCount}');
            var userId = prefs.getInt(SharedpreferencesConstant.userId);
            MySingleton.shared.userId = userId;
            Provider.of<HomeProvider>(context, listen: false)
                .getHomeData(userId)
                .then((homePageModel) {
              if (homePageModel.errorStatus) {
                UtilFunction().showToast(homePageModel.message);
                return;
              }
              setState(() {
                _isLoading = false;
                _homePageModel = homePageModel;
              });

              if (pinCodeToDisplay == null) {
                final screenSize = MediaQuery.of(context).size;
                showPincodeBox(context, screenSize);
              }
            });
          },
        );
      });
    }

    _isInit = false;
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
    Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
    var pinCodeToSend = _addressData['pinCode'];

    Provider.of<UserDetailProvider>(context, listen: false)
        .getPinDetails(pinCodeToSend)
        .then((pinCodeModel) {
      // if (pinCodeModel.errorStatus) {
      //   UtilFunction().showToast(pinCodeModel.message);
      //   return;
      // }

      FocusScope.of(context).unfocus();
      pinCodeToDisplay = pinCodeToSend.toString();
      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setString(
              SharedpreferencesConstant.pinCode, pinCodeToSend.toString());
        },
      );
      FocusScope.of(context).unfocus();
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            pinCodeModel.message,
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 4),
        ),
      );
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      _addressData['pinCode'] = '';
      Navigator.of(context, rootNavigator: true).pop('showGeneralDialog');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: Consumer<AddToCartProvider>(
      //   builder: (ctx, addToCartProvider, child) => Visibility(
      //     visible: addToCartProvider.currentvisiablity,
      //     child: ProceedToCheckOutButtion(),
      //   ),
      // ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(
                right: screenSize.width * 0.04,
                left: screenSize.width * 0.03,
              ),
              child: homeTopBar(context, screenSize),
            ),
            SizedBox(
              height: screenSize.height * 0.015,
            ),
            Container(
              margin: EdgeInsets.only(
                  right: screenSize.width * 0.020,
                  left: screenSize.width * 0.020),
              height: screenSize.height * 0.07,
              width: screenSize.width,
              child: MySearchBar(
                  screenSize: screenSize, homePageModel: _homePageModel),
            ),
            SizedBox(
              height: screenSize.height * 0.025,
            ),
            _isLoading == false && _homePageModel != null
                ? HomeWidgets(
                    screenSize: screenSize, homePageModel: _homePageModel)
                : ShimmerHomeScreen(screenSize: screenSize),
          ],
        )),
      ),
    );
  }

  Row homeTopBar(BuildContext context, Size screenSize) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Image.asset(
            Images.homeTopLogo,
            fit: BoxFit.fill,
            height: screenSize.height * 0.065,
            //width: 45,
          ),
        ),
        GestureDetector(
          onTap: () {
            showPincodeBox(context, screenSize);
          }, //HomeScreen().},
          child: Container(
            margin: EdgeInsets.only(right: screenSize.width * 0.07),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Delivering at',
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 12,
                      color: AppTheme.gryTextColor,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      Images.loc,
                      fit: BoxFit.fill,
                      height: screenSize.height * 0.022,
                    ),
                    SizedBox(
                      width: screenSize.width * 0.01,
                    ),
                    Text(
                      pinCodeToDisplay == null ? '' : pinCodeToDisplay,
                      style: TextStyle(
                        fontFamily: 'Galano Grotesque',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.push(
              context, SlideLeftRoute(page: NotificationScreen())),
          child: Container(
            margin: EdgeInsets.only(top: screenSize.height * 0.013),
            child: Stack(
              children: [
                // IconButton(
                //   icon: Icon(Icons.notifications),
                // ),
                Image.asset(
                  Images.icIcon,
                  fit: BoxFit.fill,
                  height: screenSize.height * 0.03,
                  //width: 45,
                ),

                notificationCount != 0 && notificationCount != null
                    ? new Positioned(
                        right: 2,
                        top: 2,
                        child: new Container(
                          padding: EdgeInsets.all(2),
                          height: screenSize.height * 0.02,
                          // padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: AppTheme.redButtonColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          // constraints: BoxConstraints(
                          //   minWidth: 8,
                          //   minHeight: 8,
                          // ),
                          child: Text(
                            '$notificationCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : new Container()
              ],
            ),
          ),
          // child: Image.asset(
          //   Images.icIcon,
          //   fit: BoxFit.fill,
          //   height: screenSize.height * 0.03,
          //   //width: 45,
          // ),
        ),
      ],
    );
  }

  void displayCurrentLocation() async {
    print('displayCurrentLocation');
    try {
      final location = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates =
          new Coordinates(location.latitude, location.longitude);
      var geoCoderRst =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      var pinCode = geoCoderRst.first.postalCode;
      pinCodeController.text = pinCode;

      print(' displayCurrentLocation:  ${pinCode}');
    } catch (e) {
      //print(e.toString());
      UtilFunction().showToast(
          "Please go to app setting and give the permission. Error : ${e.toString()}");
    }
  }

  void showPincodeBox(BuildContext context, Size screenSize) {
    print('showPincodeBox');
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Card(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.height * 0.05,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: screenSize.width,
                        child: Text(
                          'Check Delivery Availability',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Stack(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType
                                  .number, // Use email input type for emails.
                              decoration:
                                  InputDecoration(labelText: 'Pin Code'),
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
                            Positioned(
                              bottom: 50,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  displayCurrentLocation();
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/loction.png',
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Detect my location',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFDD2121)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.02,
                      ),
                      _isLoadingNew
                          ? Loading(
                              loadingMessage: '',
                            )
                          : GestureDetector(
                              onTap: () {
                                _submit();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: MyButton(
                                  buttonText: 'CHECK',
                                  buttonColor: AppTheme.redButtonColor,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                      SizedBox(
                        height: screenSize.height * 0.03,
                      ),
                      // : Container(
                      //     margin: EdgeInsets.all(10),
                      //     width: screenSize.width,
                      //     child: RaisedButton(
                      //       elevation: 4,
                      //       child: Text(
                      //         'SUBMIT',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       onPressed: () {
                      //         _submit();
                      //       }, //checkPinCode()},
                      //       color: AppTheme.redButtonColor,
                      //     ),
                      //   )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }
}
