
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';

class AlmanakUserTile extends StatelessWidget {
  const AlmanakUserTile({
    super.key,
    required this.user,
  });
  final AlmanakProfile user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfilePictureWidget(userId: user.lidnummer!),
      title: Text("${user.firstName!} ${user.lastName!}"),
      subtitle: Text(user.bestuursFunctie!),
    );
  }
}
