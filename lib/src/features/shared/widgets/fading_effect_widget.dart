import 'package:flutter/material.dart';

class FadingEffectWidget extends StatelessWidget {
  const FadingEffectWidget({
    Key? key,
    required this.child,
    required this.parentHeight,
  }) : super(key: key);

  final Widget child;
  final double parentHeight;

  @override
  Widget build(BuildContext context) {
    const int startAtHeight = 4;
    const double fadeOpacity = 0.24;

    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: parentHeight / startAtHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(fadeOpacity),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
