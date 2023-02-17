// write a Widget that shows the default profile picture
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class DefaultProfilePicture extends StatelessWidget {
  const DefaultProfilePicture({
    Key? key,
    this.size,
  }) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundImage: Image.asset(Images.placeholderProfilePicture).image,
    );
  }
}
