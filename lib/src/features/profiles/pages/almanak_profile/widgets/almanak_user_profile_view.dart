import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_user_data.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../api/profile_by_identifier.graphql.dart';

final CollectionReference<AlmanakProfile> people = FirebaseFirestore.instance
    .collection('people')
    .withConverter<AlmanakProfile>(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class AlmanakUserProfileView extends ConsumerWidget {
  const AlmanakUserProfileView({
    super.key,
    required this.heimdallUser,
  });

  final Query$AlmanakProfileByIdentifier$userByIdentifier heimdallUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = heimdallUser.fullContact.public;
    String userId = heimdallUser.identifier;

    // check if authenticated by Firebase
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    const double profilePictureSize = 96;
    const double elementPadding = 8;

    const double nameFontSize = 20;

    final AsyncValue<AlmanakProfile> profile =
        ref.watch(almanakUserProvider(userId));

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
        if (firebaseUser != null) // only show if authenticated by Firebase
          profile.when(
            data: (AlmanakProfile profile) => AlmanakUserData(
              u: profile,
              heimdallContact: contact,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorCardWidget(
              errorMessage: "$error",
            ), // the shown user might have no data in Firestore, in that case show nothing
          ),
      ],
    );
  }
}
