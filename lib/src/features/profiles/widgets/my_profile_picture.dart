import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_list_tile_widget.dart';
import 'package:routemaster/routemaster.dart';

class MyProfilePicture extends StatelessWidget {
  const MyProfilePicture({
    super.key,
    required this.profileIconSize,
  });

  final double profileIconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: profileIconSize,
      icon: ProfilePictureListTileWidget(
        profileId: FirebaseAuth.instance.currentUser!.uid,
      ),
      onPressed: () => Routemaster.of(context).push('edit'),
    );
  }
}
