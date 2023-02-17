// write a Widget that shows the default profile picture
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class DefaultProfilePicture extends StatelessWidget {
  const DefaultProfilePicture({
    Key? key,
    this.radius,
  }) : super(key: key);

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: Image.asset(Images.placeholderProfilePicture).image,
    );
  }
}
