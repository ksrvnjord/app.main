import 'package:action_sheet/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/groups_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/ploegen_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/widgets/data_text_list_tile.dart';
import '../../../training/widgets/calendar/widgets/chip_widget.dart';
import 'user_groups_list_widget.dart';

class AlmanakUserProfileView extends ConsumerWidget {
  const AlmanakUserProfileView({
    super.key,
    required this.identifier,
  });

  final String identifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double profilePictureSize = 96;
    const double elementPadding = 8;
    const double nameFontSize = 20;
    const double formFieldPadding = 8;
    const double bestuurFontSize = 16;
    const double actionButtonSize = 96;

    final Characters yearOfArrival = identifier.characters.getRange(
      0,
      2,
    ); // aankomstjaar is de eerste 2 cijfers van het lidnummer

    final AsyncValue<FirestoreAlmanakProfile> profile =
        ref.watch(almanakUserProvider(identifier));

    final userGroups = ref.watch(groupsForUserProvider(identifier));
    final userPloegen = ref.watch(ploegenForUserProvider(identifier));

    return ListView(
      children: [
        ProfilePictureWidget(
          userId: identifier,
          size: profilePictureSize,
          thumbnail: false,
        ).padding(all: elementPadding).center(),
        profile.when(
          data: (u) => Column(
            children: [
              Text('${u.firstName} ${u.lastName}')
                  .fontSize(nameFontSize)
                  .fontWeight(FontWeight.bold)
                  .padding(top: elementPadding)
                  .center(),
              if (u.study != null)
                Text(u.study!)
                    .textColor(Colors.blueGrey)
                    .alignment(Alignment.center),
              if (u.bestuursFunctie != null)
                // make list tile with lightblue background and white text
                Center(
                  child: Card(
                      color: Colors.lightBlue,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Text(u.bestuursFunctie!)
                          .textColor(Colors.white)
                          .fontSize(bestuurFontSize)
                          .fontWeight(FontWeight.bold)
                          .padding(all: formFieldPadding)),
                ),
              [
                if (u.email != null && u.email!.isNotEmpty)
                  ElevatedButton(
                      onPressed: () =>
                          launchUrl(Uri.parse("mailto:${u.email}")),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)))),
                      child: SizedBox(
                          width: actionButtonSize,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text("Mail"),
                                Icon(Icons.mail_outline_outlined,
                                    color: Colors.white)
                              ]))).padding(all: formFieldPadding),
                if (u.phonePrimary != null && u.phonePrimary!.isNotEmpty)
                  ElevatedButton(
                      onPressed: () => showBottomActionSheet(
                          context: context,
                          children: const [
                            Icon(Icons.phone, color: Colors.black),
                            FaIcon(FontAwesomeIcons.whatsapp,
                                color: Colors.black)
                          ],
                          actions: [
                            () => launchUrl(Uri.parse("tel:${u.phonePrimary}")),
                            () => launchUrl(Uri.parse(
                                "https://wa.me/31${u.phonePrimary?.characters.getRange(1)}"))
                          ],
                          descriptions: [
                            const Text("Bel"),
                            const Text("Whatsapp")
                          ],
                          widgetPositioning: WidgetPositioning.mainAxis),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)))),
                      child: SizedBox(
                          width: actionButtonSize,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text("Telefoon"),
                                Icon(Icons.phone_iphone, color: Colors.white)
                              ]))).padding(all: formFieldPadding),
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              if (u.address != null) UserAddressWidget(address: u.address!),
              DataTextListTile(name: "Aankomstjaar", value: "20$yearOfArrival"),
              FirebaseWidget(
                onAuthenticated: userPloegen.when(
                  data: (ploegenSnapshot) => (u.ploeg == null ||
                          u.ploeg!.isEmpty ||
                          ploegenSnapshot.size > 0)
                      ? const SizedBox
                          .shrink() // user has filled in new ploegen widget, so don't show old ploegen widget
                      : DataTextListTile(name: "Ploeg", value: u.ploeg!),
                  error: (err, __) =>
                      ErrorCardWidget(errorMessage: err.toString()),
                  loading: () => const SizedBox.shrink(),
                ),
              ),
              if (u.board != null && u.board!.isNotEmpty)
                DataTextListTile(name: "Voorkeurs boord", value: u.board!),
              if (u.substructures != null && u.substructures!.isNotEmpty)
                ChipWidget(title: "Substructuren", values: u.substructures!),
              if (u.huis != null)
                DataTextListTile(name: "Huis", value: u.huis!),
              if (u.dubbellid != null && u.dubbellid!) // only show if true
                DataTextListTile(
                  name: "Dubbellid",
                  value: u.dubbellid! ? "Ja" : "Nee",
                ),
              if (u.otherAssociation != null && u.otherAssociation!.isNotEmpty)
                DataTextListTile(
                  name: "Andere vereniging(en)",
                  value: u.otherAssociation!,
                ),
              FirebaseWidget(
                onAuthenticated: userGroups.when(
                  data: (snapshot) => UserGroupsListWidget(
                    snapshot: snapshot,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stacktrace) =>
                      ErrorCardWidget(errorMessage: error.toString()),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stacktrace) => ErrorCardWidget(
            errorMessage: "$error $stacktrace",
          ),
        ),
      ],
    );
  }
}
