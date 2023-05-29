import 'package:action_sheet/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/groups_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/ploegen_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
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
    const double formFieldPadding = 8;
    const double actionButtonSize = 96;

    final Characters yearOfArrival = identifier.characters.getRange(
      0,
      2,
    ); // Aankomstjaar is de eerste 2 cijfers van het lidnummer.

    final AsyncValue<FirestoreAlmanakProfile> profile =
        ref.watch(almanakUserProvider(identifier));

    final userGroups = ref.watch(groupsForUserProvider(identifier));
    final userPloegen = ref.watch(ploegenForUserProvider(identifier));

    final textTheme = Theme.of(context).textTheme;

    return ListView(
      children: [
        ProfilePictureWidget(
          userId: identifier,
          size: profilePictureSize,
          thumbnail: false,
        ).padding(all: elementPadding).center(),
        profile.when(
          data: (u) {
            return [
              Text(
                '${u.firstName} ${u.lastName}',
                style: textTheme.headlineSmall,
              ).center(),
              if (u.study != null)
                Text(
                  u.study ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ).alignment(Alignment.center),
              if (u.bestuursFunctie != null)
                // Make list tile with lightblue background and white text.
                Center(
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Text(
                      u.bestuursFunctie ?? "",
                      style: textTheme.titleSmall,
                    ).padding(all: formFieldPadding),
                  ),
                ),
              [
                if (u.email != null && (u.email as String).isNotEmpty)
                  ElevatedButton(
                    onPressed: () => launchUrl(Uri.parse("mailto:${u.email}")),
                    child: const SizedBox(
                      width: actionButtonSize,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.mail_outline_outlined,
                          ),
                          Text("Mail"),
                        ],
                      ),
                    ),
                  ).padding(all: formFieldPadding),
                if (u.phonePrimary != null &&
                    (u.phonePrimary as String).isNotEmpty)
                  ElevatedButton(
                    onPressed: () => showBottomActionSheet(
                      context: context,
                      children: const [
                        Icon(Icons.phone, color: Colors.black),
                        FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.black,
                        ),
                      ],
                      actions: [
                        () => launchUrl(Uri.parse("tel:${u.phonePrimary}")),
                        () => launchUrl(Uri.parse(
                              "https://wa.me/31${u.phonePrimary?.characters.getRange(1)}",
                            )),
                      ],
                      descriptions: [
                        const Text("Bel"),
                        const Text("Whatsapp"),
                      ],
                      widgetPositioning: WidgetPositioning.mainAxis,
                    ),
                    child: const SizedBox(
                      width: actionButtonSize,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.phone_iphone),
                          Text("Telefoon"),
                        ],
                      ),
                    ),
                  ).padding(all: formFieldPadding),
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              if (u.address != null)
                UserAddressWidget(address: u.address as Address),
              DataTextListTile(
                name: "Aankomstjaar",
                value: "20$yearOfArrival",
              ),
              FirebaseWidget(
                onAuthenticated: userPloegen.when(
                  data: (ploegenSnapshot) => (u.ploeg == null ||
                          (u.ploeg as String).isEmpty ||
                          ploegenSnapshot.size > 0)
                      ? const SizedBox
                          .shrink() // User has filled in new ploegen widget, so don't show old ploegen widget.
                      : DataTextListTile(
                          name: "Ploeg",
                          value: u.ploeg as String,
                        ),
                  error: (err, __) =>
                      ErrorCardWidget(errorMessage: err.toString()),
                  loading: () => const SizedBox.shrink(),
                ),
              ),
              if (u.board != null && (u.board as String).isNotEmpty)
                DataTextListTile(
                  name: "Voorkeurs boord",
                  value: u.board as String,
                ),
              if (u.substructures != null &&
                  (u.substructures as List<String>).isNotEmpty)
                ChipWidget(
                  title: "Substructuren",
                  values: u.substructures as List<String>,
                ),
              if (u.huis != null)
                DataTextListTile(name: "Huis", value: u.huis as String),
              if (u.dubbellid != null &&
                  u.dubbellid as bool) // Only show if true.
                DataTextListTile(
                  name: "Dubbellid",
                  value: u.dubbellid as bool ? "Ja" : "Nee",
                ),
              if (u.otherAssociation != null &&
                  (u.otherAssociation as String).isNotEmpty)
                DataTextListTile(
                  name: "Andere vereniging(en)",
                  value: u.otherAssociation as String,
                ),
              FirebaseWidget(
                onAuthenticated: userGroups.when(
                  data: (snapshot) => UserGroupsListWidget(
                    snapshot: snapshot,
                  ).padding(vertical: elementPadding),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stacktrace) =>
                      ErrorCardWidget(errorMessage: error.toString()),
                ),
              ),
            ].toColumn();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stacktrace) => ErrorCardWidget(
            errorMessage: "$error $stacktrace",
          ),
        ),
      ],
    );
  }
}
