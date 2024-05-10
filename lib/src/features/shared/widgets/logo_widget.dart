import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String image;

  const LogoWidget({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    const double landscapeImageHeightModifier = 0.08;
    const double portraitImageHeightModifier = 0.2;

    final double imageHeightModifier =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? portraitImageHeightModifier
            : landscapeImageHeightModifier;

    return Image.asset(
      image,
      height: MediaQuery.of(context).size.width * imageHeightModifier,
    );
  }
}
