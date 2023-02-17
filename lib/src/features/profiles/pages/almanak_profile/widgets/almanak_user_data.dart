import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/copyable_form_field.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
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

    const double formFieldPadding = 8;

    return <Widget>[
      if (user.study != null) Text(user.study!).textColor(Colors.blueGrey),
      if (user.phonePrimary != null)
        CopyableFormField(label: "Telefoonnummer", value: user.phonePrimary!)
            .padding(all: formFieldPadding),
      if (user.email != null)
        CopyableFormField(label: "Email", value: user.email!)
            .padding(all: formFieldPadding),
      if (user.ploeg != null)
        DataTextListTile(name: "Ploeg", value: user.ploeg!),
      if (user.board != null)
        DataTextListTile(name: "Boord", value: user.board!),
    ].toColumn();
  }
}
