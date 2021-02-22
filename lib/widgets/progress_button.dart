import 'dart:async';
import 'package:Machranga/util/constant_text.dart';
import 'package:Machranga/util/styling.dart';
import 'package:flutter/material.dart';

import 'my_button.dart';

class ProgressButton extends StatefulWidget {
  ProgressButton({this.title});

  final String title;

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Align(
            alignment: Alignment.center,
            child: PhysicalModel(
              elevation: 8,
              shadowColor: AppTheme.redButtonColor,
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                key: _globalKey,
                height: 48,
                width: _width,
                child: 
                RaisedButton(
                  animationDuration: Duration(milliseconds: 1000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(0),
                  child: setUpButtonChild(),
                  onPressed: () {
                    setState(() {
                      if (_state == 0) {
                        animateButton();
                      }
                    });
                  },
                  elevation: 4,
                  color: Colors.lightGreen,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setUpButtonChild() {
    if (_state == 0) {
      return MyButton(
        buttonText: ConstantText.LOGIN_BUTTON,
        buttonColor: AppTheme.redButtonColor,
        textColor: Colors.white,
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return MyButton(
        buttonText: ConstantText.LOGIN_BUTTON,
        buttonColor: AppTheme.redButtonColor,
        textColor: Colors.white,
      );
    }
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

    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
}
