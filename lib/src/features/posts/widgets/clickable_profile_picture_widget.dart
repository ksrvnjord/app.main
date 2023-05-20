import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/almanak_profile_page.dart';
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
      child: ProfilePictureWidget(
        userId: userId,
        size: size,
        zoomable: false,
        thumbnail: true,
      ),
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => AlmanakProfilePage(userId: userId),
      )),
    );
  }
}
