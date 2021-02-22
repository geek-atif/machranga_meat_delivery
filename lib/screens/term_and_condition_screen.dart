import 'package:Machranga/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermAndConditionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String termAndCondition = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Terms And Condition',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Html(
            data: termAndCondition,
          ),
        ),
      ),
    );
  }
}
