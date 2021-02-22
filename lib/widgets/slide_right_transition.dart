import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(
          fullscreenDialog: true,
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          // transitionsBuilder: (BuildContext context, Animation<double> animation,
          // Animation<double> secondaryAnimation, Widget child) {
          //   return  SlideTransition(
          //     position:  Tween<Offset>(
          //       begin: const Offset(-1.0, 0.0),
          //       end: Offset.zero,
          //     ).animate(animation),
          //     child: child,
          //    );
          //  }

          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity:
                  animation, // CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
              child: child,
            );
          },
        );
}
