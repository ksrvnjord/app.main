import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
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
      icon: ProfilePictureWidget(
        userId: GetIt.I.get<CurrentUser>().user!.identifier,
      ),
      onPressed: () => Routemaster.of(context).push('edit'),
    );
  }
}
