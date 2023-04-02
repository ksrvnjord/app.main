import 'package:action_sheet/action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/widgets/data_text_list_tile.dart';
import '../../../../shared/widgets/future_wrapper.dart';
import '../../../../training/widgets/calendar/widgets/chip_widget.dart';
import '../../../api/user_commissies.dart';
import 'commissies_list_widget.dart';

final CollectionReference<AlmanakProfile> people = FirebaseFirestore.instance
    .collection('people')
    .withConverter<AlmanakProfile>(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

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

    final String yearOfArrival = identifier.substring(
      0,
      2,
    ); // aankomstjaar is de eerste 2 cijfers van het lidnummer

    final AsyncValue<AlmanakProfile> profile =
        ref.watch(almanakUserProvider(identifier));

    return ListView(
      children: [
        ProfilePictureWidget(
          userId: identifier,
          size: profilePictureSize,
        ).padding(all: elementPadding).center(),
        profile.when(
          data: (AlmanakProfile u) => Column(
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
                    elevation: 0,
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
              [
                if (u.email != null && u.email!.isNotEmpty)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                    onPressed: () => launchUrl(Uri.parse("mailto:${u.email}")),
                    child: SizedBox(
                      width: actionButtonSize,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          // mail icon
                          Text("Mail"),
                          Icon(
                            Icons.mail_outline_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ).padding(all: formFieldPadding),
                if (u.phonePrimary != null && u.phonePrimary!.isNotEmpty)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                    onPressed: () => showBottomActionSheet(
                      context: context,
                      widgetPositioning: WidgetPositioning.mainAxis,
                      children: const [
                        Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.black,
                        ),
                      ],
                      descriptions: [
                        const Text("Bel"),
                        const Text("Whatsapp"),
                      ],
                      actions: [
                        () => launchUrl(Uri.parse("tel:${u.phonePrimary}")),
                        () => launchUrl(Uri.parse(
                              "https://wa.me/31${u.phonePrimary?.substring(1)}", // 0612345678 -> 31612345678
                            )),
                      ],
                    ),
                    child: SizedBox(
                      width: actionButtonSize,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          // phone icon
                          Text("Telefoon"),
                          Icon(
                            Icons.phone_iphone,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ).padding(all: formFieldPadding),
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              UserAddressWidget(address: u.address!),
              DataTextListTile(name: "Aankomstjaar", value: "20$yearOfArrival"),
              if (u.ploeg != null && u.ploeg!.isNotEmpty)
                DataTextListTile(name: "Ploeg", value: u.ploeg!),
              if (u.board != null && u.board!.isNotEmpty)
                DataTextListTile(name: "Voorkeurs boord", value: u.board!),
              if (u.substructuren != null && u.substructuren!.isNotEmpty)
                ChipWidget(title: "Substructuren", values: u.substructuren!),
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
              if (FirebaseAuth.instance.currentUser != null)
                FutureWrapper(
                  future:
                      ref.watch(commissiesForUserProvider(u.lidnummer).future),
                  success: (snapshot) => CommissiesListWidget(
                    snapshot: snapshot,
                    legacyCommissies: u.commissies,
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
