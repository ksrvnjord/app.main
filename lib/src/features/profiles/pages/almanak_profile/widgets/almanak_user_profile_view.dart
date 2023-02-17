import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            .padding(top: elementPadding)
            .center(),
        FutureWrapper(
          future: getFirestoreProfileData(userId),
          success: (AlmanakProfile profile) =>
              AlmanakUserData(user: profile, heimdallContact: contact),
        ),
      ],
    );
  }
}
