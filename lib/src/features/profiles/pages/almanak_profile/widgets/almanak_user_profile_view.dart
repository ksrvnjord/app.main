import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_profile_bottomsheet_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_user_data.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

final CollectionReference<AlmanakProfile> people = FirebaseFirestore.instance
    .collection('people')
    .withConverter<AlmanakProfile>(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class AlmanakUserProfileView extends StatelessWidget {
  const AlmanakUserProfileView({
    super.key,
    required this.heimdallUser,
  });

  final Query$AlmanakProfile$user heimdallUser;

  @override
  Widget build(BuildContext context) {
    Query$AlmanakProfile$user$fullContact$public contact =
        heimdallUser.fullContact.public;
    String userId = heimdallUser.identifier;

    const double profilePictureSize = 96;
    const double elementPadding = 8;

    const double nameFontSize = 20;

    return ListView(
      children: [
        ProfilePictureWidget(
          userId: heimdallUser.identifier,
          size: profilePictureSize,
        ).padding(all: elementPadding).center(),
        Text('${contact.first_name} ${contact.last_name}')
            .fontSize(nameFontSize)
            .fontWeight(FontWeight.bold)
            .padding(all: elementPadding)
            .center(),
        FutureWrapper(
          future: getFirestoreProfileData(userId),
          success: (AlmanakProfile profile) =>
              AlmanakUserData(user: profile, heimdallContact: contact),
        ),
      ],
    );
  }

  Widget showUserProfile(Query$AlmanakProfile$user? user) {
    final contact = user!.fullContact.public;

    const List<String> labels = [
      'Naam',
      'Telefoonnummer',
      'E-mailadres',
      'Adres',
      'Postcode',
      'Woonplaats',
    ];

    final List<String> values = [
      '${contact.first_name} ${contact.last_name}',
      contact.phone_primary ?? '',
      contact.email ?? '',
      contact.street != ''
          ? '${contact.street ?? ''} ${contact.housenumber ?? ''} ${contact.housenumber_addition ?? ''}'
          : '',
      contact.zipcode ?? ' ',
      contact.city ?? ' ',
    ];

    const double textFieldPadding = 16;

    return Column(
      children: [
        // ignore: avoid-shrink-wrap-in-lists
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: labels.length,
          itemBuilder: (BuildContext context, int index) {
            if (values[index] != '') {
              return GestureDetector(
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: labels[index],
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  initialValue: values[index],
                ).padding(all: textFieldPadding),
                onLongPress: () => vibrateAndshowBottomSheet(
                  context,
                  labels[index],
                  values[index],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  void vibrateAndshowBottomSheet(context, label, value) {
    HapticFeedback.vibrate();
    showModalBottomSheet(
      context: context,
      builder: (_) => AlmanakProfileBottomsheetWidget(
        label: label,
        value: value,
      ),
    );
  }
}
