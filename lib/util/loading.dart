import '../util/styling.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.redButtonColor),
      ),
    );
    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       // Text(
    //       //   loadingMessage,
    //       //   textAlign: TextAlign.center,
    //       //   style: TextStyle(
    //       //     color: Colors.lightGreen,
    //       //     fontSize: 24,
    //       //   ),
    //       // ),
    //       //SizedBox(height: 20),
    //       CircularProgressIndicator(
    //         valueColor: AlwaysStoppedAnimation<Color>(AppTheme.redButtonColor),
    //       ),
    //     ],
    //   ),
    // );
  }
}
