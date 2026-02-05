// ignore_for_file: prefer-extracting-function-callbacks

import 'package:action_sheet/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/almanak_birthday_message_button.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/groups_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/info.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/widgets/data_text_list_tile.dart';
import '../../../training/widgets/calendar/widgets/chip_widget.dart';
import 'user_groups_list_widget.dart';

class AlmanakUserProfileView extends ConsumerWidget {
  const AlmanakUserProfileView({super.key, required this.identifier});

  final String identifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const profilePictureSize = 96.0;
    const elementPadding = 8.0;
    const formFieldPadding = 8.0;
    const actionButtonSize = 96.0;
    final yearOfArrival = identifier.characters.getRange(
        0, 2); // Aankomstjaar is de eerste 2 cijfers van het lidnummer.

    final profile = ref.watch(userProvider(identifier));

    final userGroups = ref.watch(groupsForUserProvider(identifier));

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Info userInfo;

    return ListView(
      children: [
        ProfilePictureWidget(userId: identifier, size: profilePictureSize)
            .padding(all: elementPadding)
            .center(),
        profile.when(
          // ignore: avoid-long-functions
          data: (u) {
            userInfo = u.info;
            return Column(
              children: [
                Text(
                  '${u.firstName} ${u.lastName}',
                  style: textTheme.headlineSmall,
                ).center(),
                if (u.birthDate != null && u.birthDate!.isNotEmpty)
                  Text(
                    DateFormat("d MMMM y", "nl")
                        .format(DateTime.parse(u.birthDate ?? '')),
                    style: textTheme.bodyLarge,
                  ).alignment(Alignment.center),
                if (u.bestuursFunctie != null)
                  // Make list tile with lightblue background and white text.
                  Center(
                    child: Card(
                      color: colorScheme.primaryContainer,
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
                SizedBox(
                  height: elementPadding,
                ),
                if (u.isBirthday)
                  AlmanakBirthdayButton(
                      receiverId: u.identifierString,
                      receiverFullName: u.fullName),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (u.email.isNotEmpty && u.contact.emailVisible)
                      ElevatedButton(
                        onPressed: () =>
                            // ignore: avoid-async-call-in-sync-function
                            launchUrl(Uri.parse("mailto:${u.email}")),
                        child: const SizedBox(
                          width: actionButtonSize,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.mail_outline_outlined),
                              Text("Mail"),
                            ],
                          ),
                        ),
                      ).padding(all: formFieldPadding),
                    if (u.phonePrimary != null &&
                        (u.phonePrimary as String).isNotEmpty &&
                        u.contact.phoneVisible)
                      ElevatedButton(
                        // ignore: avoid-async-call-in-sync-function
                        onPressed: () => showBottomActionSheet(
                          context: context,
                          children: [
                            Icon(Icons.phone, color: colorScheme.onSurface),
                            FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: colorScheme.onSurface,
                            ),
                          ],
                          actions: [
                            // ignore: avoid-async-call-in-sync-function
                            () => launchUrl(Uri.parse("tel:${u.phonePrimary}")),
                            () async => await launchUrl(Uri.parse(
                                  // ignore: avoid-nullable-interpolation
                                  "https://wa.me/31${u.phonePrimary!.replaceAll('-', '').characters.getRange(1)}",
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
                  ],
                ),
                DataTextListTile(
                  name: "Aankomstjaar",
                  value: "20$yearOfArrival",
                ),
                if (userInfo.studie != null &&
                    (userInfo.studie as String).isNotEmpty)
                  DataTextListTile(
                    name: "Studie",
                    value: userInfo.studie as String,
                  ),
                if (u.board != null && (u.board as String).isNotEmpty)
                  DataTextListTile(
                    name: "Voorkeurs boord",
                    value: u.board as String,
                  ),
                if (userInfo.blikken != 0)
                  DataTextListTile(
                    name: "Aantal blikken",
                    value: userInfo.blikken.toString(),
                  ),
                if (userInfo.stuurblikken != 0)
                  DataTextListTile(
                    name: "Aantal stuurblikken",
                    value: userInfo.stuurblikken.toString(),
                  ),
                if (userInfo.taarten != 0)
                  DataTextListTile(
                    name: "Aantal taarten",
                    value: userInfo.taarten.toString(),
                  ),
                if (u.substructures != null &&
                    (u.substructures as List<String>).isNotEmpty)
                  ChipWidget(
                    title: "Substructuren",
                    values: u.substructures as List<String>,
                  ),
                if (u.huis != null)
                  DataTextListTile(name: "Huis", value: u.huis as String),
                if (u.address.visible ?? false)
                  UserAddressWidget(address: u.address),
                if (u.dubbellid != null && u.dubbellid as bool)
                  // Only show if true.
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
                    data: (snapshot) => UserGroupsListWidget(snapshot: snapshot)
                        .padding(vertical: elementPadding),
                    error: (error, stacktrace) =>
                        ErrorCardWidget(errorMessage: error.toString()),
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, stacktrace) =>
              ErrorCardWidget(errorMessage: error.toString()),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ],
    );
  }
}
