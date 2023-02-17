import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/copyable_form_field.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/chip_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakUserData extends StatelessWidget {
  const AlmanakUserData({
    Key? key,
    required this.u,
    required this.heimdallContact,
  }) : super(key: key);

  // since user data is stored in Firestore and Heimdall, we need to pass both
  final AlmanakProfile u;
  final Query$AlmanakProfile$user$fullContact$public heimdallContact;

  @override
  Widget build(BuildContext context) {
    // we are going to merge the heimdall user into the firestore user so we can use the same model
    u.mergeWithHeimdallProfile(heimdallContact);

    const double formFieldPadding = 8;
    const double bestuurFontSize = 20;

    return <Widget>[
      if (u.study != null) Text(u.study!).textColor(Colors.blueGrey),
      if (u.bestuursFunctie != null)
        // make list tile with lightblue background and white text
        Center(
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            color: Colors.lightBlue,
            child: Text(u.bestuursFunctie!)
                .textColor(Colors.white)
                .fontSize(bestuurFontSize)
                .fontWeight(FontWeight.bold)
                .padding(all: formFieldPadding),
          ),
        ),
      if (u.phonePrimary != null && u.phonePrimary!.isNotEmpty)
        CopyableFormField(label: "Telefoonnummer", value: u.phonePrimary!)
            .padding(all: formFieldPadding),
      if (u.email != null && u.email!.isNotEmpty)
        CopyableFormField(label: "Email", value: u.email!)
            .padding(all: formFieldPadding),
      UserAddressWidget(address: u.address!),
      if (u.ploeg != null) DataTextListTile(name: "Ploeg", value: u.ploeg!),
      if (u.board != null)
        DataTextListTile(name: "Voorkeurs boord", value: u.board!),
      if (u.commissies != null)
        ChipWidget(title: "Commissies", values: u.commissies!),
      if (u.substructuren != null)
        ChipWidget(title: "Substructuren", values: u.substructuren!),
      if (u.huis != null) DataTextListTile(name: "Huis", value: u.huis!),
      if (u.dubbellid != null)
        DataTextListTile(
          name: "Dubbellid",
          value: u.dubbellid! ? "Ja" : "Nee",
        ),
      if (u.otherAssociation != null)
        DataTextListTile(
          name: "Andere vereniging(en)",
          value: u.otherAssociation!,
        ),
    ].toColumn();
  }
}
