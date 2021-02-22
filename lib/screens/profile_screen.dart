import '../util/util_function.dart';
import '../widgets/shimmer_profile_screen.dart';
import '../models/user_deatil_model.dart';
import '../util/constant.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_detail_provider.dart';
import 'package:provider/provider.dart';
import '../util/images.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isLoading = false;
  UserDeatilModel userDeatilModel;
  getAllData(userID) {
    UtilFunction.isJWTValid().then((isJWTValid) {
      if (!isJWTValid) {
        UtilFunction.logout(context);
        return;
      }
      setState(() {
        _isLoading = true;
      });

      Provider.of<UserDetailProvider>(context, listen: false)
          .getUserDetail(userID)
          .then((userDetail) {
        if (userDetail.errorStatus) {
          setState(() {
            _isLoading = false;
          });
          UtilFunction().showToast(userDetail.message);
          return;
        }
        userDeatilModel = userDetail;
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var userID = prefs.getInt(SharedpreferencesConstant.userId);
      getAllData(userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _isLoading
                  ? ShimmerProfileScreen(
                      screenSize: screenSize,
                    )
                  : userDetailData(userDeatilModel, screenSize),
              Container(
                width: screenSize.width,
                height: screenSize.height * 0.2,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      Images.splashlogo,
                      height: screenSize.height * 0.15,
                      width: screenSize.width * 0.3,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () {
                        UtilFunction.logout(context);
                      },
                      child: Container(
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(
                              color: AppTheme.redButtonColor, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column userDetailData(UserDeatilModel userDeatilModel, Size screenSize) {
    if (userDeatilModel == null)
      return Column(
        children: <Widget>[],
      );
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Text(
            'PROFILE',
            style: TextStyle(
                fontFamily: 'Galano Grotesque',
                color: Colors.black,
                fontSize: 18),
          ),
        ),
        userDeatilModel.userDeatil.imageUrl.isEmpty
            ? Container(
                margin: EdgeInsets.only(top: 10),
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      Images.profileImage,
                    ),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.only(top: 10),
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      userDeatilModel.userDeatil.imageUrl,
                    ),
                  ),
                ),
              ),
        Container(
          child: Text(
            userDeatilModel.userDeatil.name,
            style: TextStyle(fontSize: 18, fontFamily: 'Galano Grotesque'),
          ),
        ),
        Container(
          child: Text(
            userDeatilModel.userDeatil.email,
            style: TextStyle(fontSize: 14, fontFamily: 'Muli'),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(Constant.PROFILE_UPDATE_SCREEN,
                arguments: userDeatilModel);
          },
          child: Container(
            child: Text(
              'Edit Profile',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                  color: AppTheme.redButtonColor),
            ),
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.03,
        ),
        InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(Constant.FAQS_ROUTE_NAME,
                  arguments: userDeatilModel.faqs);
            },
            child: middelWidget(
                Images.faq, 'FAQ’s', 'Frequently asked questions')),
        Container(
          margin: EdgeInsets.only(left: 25, right: 20),
          child: Divider(),
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    showContactUs(userDeatilModel.contactDetail));
          },
          child: middelWidget(
              Images.support, 'Support', 'Contact details Machranga'),
        ),
        Container(
          margin: EdgeInsets.only(left: 25, right: 20),
          child: Divider(),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(Constant.TERMANDCOD_ROUTE_NAME,
                arguments: userDeatilModel.termsCodition.termsCoditionContent);
          },
          child: middelWidget(
              Images.term, 'Terms and conditions', 'While using Machranga'),
        ),
        SizedBox(
          height: screenSize.height * 0.04,
        ),
      ],
    );
  }

  ListTile middelWidget(String ellipse, String title, String subTitle) {
    return ListTile(
      leading: Image.asset(
        ellipse,
        height: 40,
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 45,
        color: AppTheme.arrowColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'Galano Grotesque',
        ),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Muli',
        ),
      ),
    );
  }

  showContactUs(ContactDetail contactDetail) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      backgroundColor: Colors.white,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Contact Details',
              style: TextStyle(
                fontFamily: 'Galano Grotesque',
                fontSize: 16,
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.call,
                size: 25,
                color: Colors.black,
              ),
              title: Text(
                'Mobile Number',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Galano Grotesque',
                ),
              ),
              subtitle: Text(
                contactDetail.phone.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                ),
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.email,
                size: 25,
                color: Colors.black,
              ),
              title: Text(
                'emails',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Galano Grotesque',
                ),
              ),
              subtitle: Text(
                contactDetail.email,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
