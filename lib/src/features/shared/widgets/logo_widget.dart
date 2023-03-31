import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;

  const LogoWidget({
    Key? key,
    required this.image,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double landscapeImageHeightModifier = 0.1;
    const double portraitImageHeightModifier = 0.18;

    final double imageHeightModifier =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? portraitImageHeightModifier
            : landscapeImageHeightModifier;

    return Image.asset(
      image,
      height: height,
      width: width,
    );
  }
}
