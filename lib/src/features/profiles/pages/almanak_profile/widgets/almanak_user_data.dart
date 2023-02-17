import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/copyable_form_field.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/chip_widget.dart';
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
      if (user.phonePrimary != null && user.phonePrimary!.isNotEmpty)
        CopyableFormField(label: "Telefoonnummer", value: user.phonePrimary!)
            .padding(all: formFieldPadding),
      if (user.email != null && user.email!.isNotEmpty)
        CopyableFormField(label: "Email", value: user.email!)
            .padding(all: formFieldPadding),
      if (user.ploeg != null)
        DataTextListTile(name: "Ploeg", value: user.ploeg!),
      if (user.board != null)
        DataTextListTile(name: "Voorkeurs boord", value: user.board!),
      if (user.commissies != null) // map commissies to chips
        ChipWidget(title: "Commissies", values: user.commissies!),
      if (user.huis != null) DataTextListTile(name: "Huis", value: user.huis!),
      if (user.substructuren != null) // map substructuren to chips
        ChipWidget(title: "Substructuren", values: user.substructuren!),
      if (user.dubbellid != null)
        DataTextListTile(
          name: "Dubbellid",
          value: user.dubbellid! ? "Ja" : "Nee",
        ),
      UserAddressWidget(address: user.address!),
    ].toColumn();
  }
}

class UserAddressWidget extends StatelessWidget {
  const UserAddressWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    const double formFieldPadding = 8;

    return Row(
      children: [
        if (address.street != null && address.street!.isNotEmpty)
          Text(address.street!),
        if (address.houseNumber != null && address.houseNumber!.isNotEmpty)
          Text(address.houseNumber!),
        if (address.houseNumberAddition != null &&
            address.houseNumberAddition!.isNotEmpty)
          Text(address.houseNumberAddition!),
        if (address.postalCode != null && address.postalCode!.isNotEmpty)
          Text(address.postalCode!),
        if (address.city != null && address.city!.isNotEmpty)
          Text(address.city!),
      ],
    );
  }
}
