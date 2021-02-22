import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef HeroBuilder = Widget Function(BuildContext context);

class HeroWidget extends StatelessWidget {
  final HeroBuilder heroBuilder;
  final Object heroTag;
  final VoidCallback onTap;

  const HeroWidget({
    Key key,
    @required HeroBuilder builder,
    @required this.heroTag, 
    this.onTap,
  })  : heroBuilder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      child: Hero(
        tag: heroTag,
        child: Material(
       //   color: Colors.transparent,
          child: InkWell(
            child: heroBuilder(context),
            onTap: onTap,
          ),
        ),
        // flightShuttleBuilder:
        //     (flightContext, animation, direction, fromContext, toContext) {
        //   return RotationTransition(
        //     turns: Tween(begin: 0.0, end: 1.0)
        //         .chain(CurveTween(curve: Curves.ease))
        //         .animate(animation),
        //     child: toContext.widget as Hero..child,
        //   );
        // },
      ),
    );
  }
}
