import 'package:flutter/material.dart';

class FadeBottomWidget extends StatelessWidget {
  const FadeBottomWidget({
    Key? key,
    required this.parentHeight,
    required this.child,
  }) : super(key: key);

  final double parentHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const int startAtHeight = 4;
    const double fadeOpacity = 0.24;

    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(fadeOpacity),
                  Colors.transparent,
                ],
              ),
            ),
            height: parentHeight / startAtHeight,
          ),
        ),
      ],
    );
  }
}
