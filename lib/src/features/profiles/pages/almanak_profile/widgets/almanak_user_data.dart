import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakUserData extends StatelessWidget {
  const AlmanakUserData({
    Key? key,
    required this.user,
    required this.heimdallContact,
  }) : super(key: key);

  // since user data is stored in Firestore and Heimdall, we need to pass both
  final AlmanakProfile user;
  final Query$AlmanakProfile$user$fullContact$public heimdallContact;

  @override
  Widget build(BuildContext context) {
    // we are going to merge the heimdall user into the firestore user so we can use the same model
    user.mergeWithHeimdallProfile(heimdallContact);

    return <Widget>[
      if (user.study != null) Text(user.study!),
    ].toColumn();
  }
}
