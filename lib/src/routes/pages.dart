import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

class FadePage extends Page {
  final Widget child;

  const FadePage({required this.child});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        final tween = Tween(begin: 0.0, end: 1.0);
        final curveTween = CurveTween(curve: Curves.easeInOut);

        return FadeTransition(
          opacity: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
}

class SlideLTRPage extends Page {
  final Widget child;

  const SlideLTRPage({required this.child});

  @override
  Route createRoute(BuildContext context) {
    return PageTransition(
      child: child,
      type: PageTransitionType.leftToRight,
      settings: this,
    );
  }
}
