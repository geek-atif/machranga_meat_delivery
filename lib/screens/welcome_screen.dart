import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../widgets/slide_route.dart';
import '../util/images.dart';
import '../widgets/my_button.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';
import '../util/constant_text.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: screenSize.height * 0.02),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/group_welcome.png',
                  fit: BoxFit.fill,
                  height: screenSize.height * 0.14,
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                child: Text(
                  ConstantText.WCL_HEAD,
                  style: TextStyle(
                    fontFamily: 'Galano Grotesque',
                    fontSize: 26,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8, left: 8),
                child: Text(
                  ConstantText.WCL_SUB_HEAD,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Muli',
                    color: AppTheme.gryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: screenSize.height * 0.5,
                alignment: Alignment.center,
                child: Image.asset(
                  Images.welcomeScreen,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: screenSize.height * 0.03,
              ),
              flex: 0,
            ),
            Expanded(
              flex: 0,
              child: Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, SlideLeftRoute(page: SignupScreen()));
                  },
                  child: MyButton(
                    buttonText: ConstantText.WCL_SUB_START_BUTTON,
                    buttonColor: AppTheme.redButtonColor,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: screenSize.height * 0.02,
              ),
              flex: 0,
            ),
            Expanded(
              flex: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: MyButton(
                    buttonText: ConstantText.LOGIN_BUTTON,
                    buttonColor: AppTheme.gryButtonColor,
                    textColor: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: screenSize.height * 0.05,
              ),
              flex: 0,
            ),
          ],
        )),
      ),
    );
  }
}
