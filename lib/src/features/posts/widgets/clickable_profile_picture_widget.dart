import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';

class ClickableProfilePictureWidget extends StatelessWidget {
  const ClickableProfilePictureWidget({
    Key? key,
    required this.userId,
    // ignore: no-magic-number
    this.size = 16,
  }) : super(key: key);

  final String userId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => // push AlmanakProfilePage with Navigator
          Navigator.of(context).push(CupertinoPageRoute(
        // don't make separate route in Routemap because it would not make sense to make a /posts/:userId route
        builder: (context) => AlmanakProfilePage(userId: userId),
      )),
      child: ProfilePictureWidget(userId: userId),
    );
  }
}
