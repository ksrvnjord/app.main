import 'package:action_sheet/action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/chip_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
    const double bestuurFontSize = 16;
    const double actionButtonSize = 96;

    const double fieldTitleFontSize = 16;
    const double fieldTitlePadding = 16;

    return <Widget>[
      if (u.study != null)
        Text(u.study!).textColor(Colors.blueGrey).alignment(Alignment.center),
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
      if (u.ploeg != null) DataTextListTile(name: "Ploeg", value: u.ploeg!),
      if (u.board != null)
        DataTextListTile(name: "Voorkeurs boord", value: u.board!),
      if (u.substructuren != null && u.substructuren!.isNotEmpty)
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
      FutureWrapper(
        future: getCommissiesForUser<Future<QuerySnapshot<CommissieEntry>>>(
          u.lidnummer,
        ),
        success: (snapshot) => CommissiesListWidget(
          snapshot: snapshot,
          legacyCommissies: u.commissies,
        ),
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }
}

class CommissiesListWidget extends StatelessWidget {
  const CommissiesListWidget({
    Key? key,
    required this.snapshot,
    required this.legacyCommissies, // TODO: remove this after 1 june 2023, this is to support old way to enter commissies
  }) : super(key: key);

  final QuerySnapshot<CommissieEntry> snapshot;
  final List<String>? legacyCommissies;

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<CommissieEntry>> docs = snapshot.docs;
    docs.sort((a, b) => -1 * a.data().startYear.compareTo(b.data().startYear));

    const double fieldTitleFontSize = 16;
    const double fieldTitlePadding = 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: docs.isNotEmpty
          ? [
              const Text("Commissies")
                  .fontSize(fieldTitleFontSize)
                  .textColor(Colors.grey)
                  .padding(horizontal: fieldTitlePadding),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              docs
                  .map(
                    (doc) => [
                      ListTile(
                        tileColor: Colors.white,
                        title: Text(doc.data().name),
                        subtitle: <Widget>[
                          Chip(
                            label: Text(
                              "${doc.data().startYear}-${doc.data().endYear ?? "heden"}",
                            ),
                            avatar: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 16,
                            ),
                            backgroundColor: Colors.lightBlue,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          if (doc.data().function != null &&
                              doc.data().function!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Chip(label: Text(doc.data().function!)),
                            ),
                        ].toRow(),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ].toColumn(),
                  )
                  .toList()
                  .toColumn(),
            ]
          : [
              legacyCommissies != null && legacyCommissies!.isNotEmpty
                  ? ChipWidget(title: "Commissies", values: legacyCommissies!)
                  : Container(),
            ],
    );
  }
}
