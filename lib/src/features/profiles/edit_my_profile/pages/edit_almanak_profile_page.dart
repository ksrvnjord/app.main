import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/profile_edit_form_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/edit_profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/user_id.dart';
import 'package:routemaster/routemaster.dart';
import 'dart:io';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/houses.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:styled_widget/styled_widget.dart';

class EditAlmanakProfilePage extends ConsumerStatefulWidget {
  const EditAlmanakProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _EditAlmanakProfilePageState();
}

class _EditAlmanakProfilePageState
    extends ConsumerState<EditAlmanakProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userVal = ref.watch(firestoreUserFutureProvider(getCurrentUserId()));
    final userId = ref.watch(firebaseAuthUserProvider)!.uid;

    const double floatingActionButtonSpacing = 16;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wijzig mijn almanak profiel'),
        actions: [
          IconButton(
            onPressed: () => Routemaster.of(context).push('visibility'),
            icon: const Icon(Icons.visibility_outlined),
          ),
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: userVal.when(
        data: (user) => buildForm(
          user,
          context,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
      ),
      floatingActionButton: // Floating action button with save icon.
          [
        FloatingActionButton.extended(
          backgroundColor: Colors.blueGrey,
          onPressed: () => Routemaster.of(context).push(userId),
          label: const Text("Publiek profiel bekijken"),
        ),
        FloatingActionButton.extended(
          onPressed: submitForm,
          icon: const Icon(Icons.save),
          label: const Text('Opslaan'),
        ),
      ].toWrap(
        spacing: floatingActionButtonSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
      ),
    );
  }

  ListView buildForm(
    QueryDocumentSnapshot<FirestoreAlmanakProfile> snapshot,
    BuildContext context,
  ) {
    final user = snapshot.data();

    const double imageHelpTextSize = 12;
    const double imageHelpTextTopPadding = 4;
    const double groupSpacing = 32;

    return ListView(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 80),
      children: [
        Form(
          key: _formKey,
          child: <Widget>[
            [
              const EditProfilePictureWidget(),
              const Text(
                'Het kan even duren voordat iedereen je nieuwe foto ziet',
              )
                  .textColor(Colors.grey)
                  .textAlignment(TextAlign.center)
                  .fontSize(imageHelpTextSize),
            ]
                .toColumn(
                  separator: const SizedBox(height: imageHelpTextTopPadding),
                )
                .center(),
            FormSection(title: "Over mij", children: [
              TextFormField(
                initialValue: user.study,
                decoration: const InputDecoration(
                  labelText: 'Studie',
                  hintText: 'Rechten, Geneeskunde, etc.',
                ),
                onSaved: (study) => ref
                    .read(profileEditFormNotifierProvider.notifier)
                    .setStudy(study),
              ),
              DropdownButtonFormField<String?>(
                items: ['Bakboord', 'Stuurboord', 'Scull', 'Multiboord']
                    .map((board) => DropdownMenuItem<String>(
                          value: board,
                          child: Text(board),
                        ))
                    .toList(),
                value: user.board,
                hint: const Text('Welk boord?'),
                onChanged: (_) => {},
                decoration: const InputDecoration(
                  labelText: 'Boord',
                  hintText: 'Welk boord roei je?',
                ),
                onSaved: (value) => ref
                    .read(profileEditFormNotifierProvider.notifier)
                    .setBoard(value),
              ),
            ]),
            FormSection(
              title: "Mijn groepen",
              children: [
                ListTile(
                  title: const Text('Beheer mijn ploegen'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.lightBlue,
                  ),
                  onTap: () => Routemaster.of(context).push(
                    'groups',
                  ), // In de toekomst willen we niet alleen dat ploegen worden weergegeven, maar ook commissies en andere groepen.
                ),
                ListTile(
                  title: const Text('Beheer mijn commissies'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.lightBlue,
                  ),
                  onTap: () => Routemaster.of(context).push('commissies'),
                ),
                DropdownButtonFormField<String?>(
                  items: ['Geen', ...houseNames]
                      .map((house) => DropdownMenuItem<String>(
                            value: house,
                            child: Text(house),
                          ))
                      .toList(),
                  value: user.huis,
                  hint: const Text('Geen'),
                  onChanged: (_) => {},
                  decoration: const InputDecoration(labelText: 'Njord-huis'),
                  onSaved: (huis) => ref
                      .read(profileEditFormNotifierProvider.notifier)
                      .setHuis(huis),
                ),
                MultiSelectDialogField<String>(
                  items: substructures.map((structure) =>
                      // ignore: no-equal-arguments
                      MultiSelectItem<String>(structure, structure)).toList(),
                  onConfirm: (_) => {},
                  title: const Text('Substructuren'),
                  // ignore: no-equal-arguments
                  buttonText: const Text('Substructuren'),
                  onSaved: (substructures) => ref
                      .read(profileEditFormNotifierProvider.notifier)
                      .setSubstructuren(substructures),
                  initialValue: user.substructures ?? [],
                ),
                DropdownButtonFormField<bool?>(
                  items: const [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Ja, bij L.S.V. Minerva'),
                    ),
                    DropdownMenuItem(value: false, child: Text('Nee')),
                  ],
                  value: user.dubbellid,
                  hint: const Text('Ben je dubbellid?'),
                  onChanged: (_) => {},
                  decoration: const InputDecoration(labelText: 'Dubbellid'),
                  onSaved: (dubbellib) => ref
                      .read(profileEditFormNotifierProvider.notifier)
                      .setDubbellid(dubbellib),
                ),
                TextFormField(
                  initialValue: user.otherAssociation,
                  decoration: const InputDecoration(
                    labelText: 'Zit je bij een andere vereniging?',
                    hintText: 'L.V.V.S. Augustinus, etc.',
                  ),
                  onSaved: (value) => ref
                      .read(profileEditFormNotifierProvider.notifier)
                      .setOtherAssociation(value),
                ),
              ],
            ),
            // Add a TextFormField for the team the user is in.
          ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separator: const SizedBox(height: groupSpacing),
          ),
        ),
      ],
    );
  }

  void submitForm() async {
    // FORM VALIDATION.
    if (!_formKey.currentState!.validate()) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sommige velden zijn niet juist ingevuld'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }
    bool success = true; // On errors set to false.
    // Get user id from FirebaseAuth.

    // FIND DOCUMENT OF CURRENT USER.
    final querySnapshot = await FirebaseFirestore.instance
        .collection('people')
        .withConverter<FirestoreAlmanakProfile>(
          fromFirestore: (snapshot, _) =>
              FirestoreAlmanakProfile.fromFirestore(snapshot.data()!),
          toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
        )
        .where('identifier', isEqualTo: getCurrentUserId())
        .get();

    // SAVE FORM.
    _formKey.currentState?.save();

    // UPLOAD FORM TO FIRESTORE.
    final ProfileForm form = ref.read(profileEditFormNotifierProvider);
    await querySnapshot.docs.first.reference
        .update(form.toJson())
        .catchError((err) {
      success = false;
    });

    ref.invalidate(firestoreUserFutureProvider); // Invalidate cache.

    // PROFILE PICTURE UPLOAD.
    final File? newprofilePicture = form.profilePicture;
    if (newprofilePicture != null) {
      try {
        // ignore: avoid-ignoring-return-values
        CachedProfilePicture.uploadMyProfilePicture(newprofilePicture);
        // ignore: avoid-ignoring-return-values
        profilePictureProvider(getCurrentUserId())
            .overrideWith((ref) => Image.file(newprofilePicture).image);
      } on FirebaseException catch (_) {
        success = false;
      }
    }

    // SHOW CONFIRMATION TO USER.
    if (context.mounted) {
      if (success) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Je profiel is succesvol gewijzigd'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Er ging iets mis bij het wijzigen van je profiel'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
