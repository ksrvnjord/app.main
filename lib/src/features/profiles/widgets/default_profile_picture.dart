// write a Widget that shows the default profile picture
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class DefaultProfilePicture extends StatelessWidget {
  const DefaultProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: Image.asset(Images.placeholderProfilePicture).image,
    );
  }
}
