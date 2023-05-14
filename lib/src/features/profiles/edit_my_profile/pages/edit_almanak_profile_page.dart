import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/profile_edit_form_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/edit_profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
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
    const double imageHelpTextSize = 12;
    const double imageHelpTextTopPadding = 4;
    const double groupSpacing = 32;

    final userVal = ref.watch(firestoreUserFutureProvider(getCurrentUserId()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wijzig mijn almanak profiel'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility_outlined),
            onPressed: () => Routemaster.of(context).push('visibility'),
          ),
        ],
      ),
      body: userVal.when(
        data: (user) => ListView(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 80),
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
                      separator:
                          const SizedBox(height: imageHelpTextTopPadding),
                    )
                    .center(),
                FormSection(title: "Over mij", children: [
                  TextFormField(
                    initialValue: user.data().study,
                    onSaved: (study) => ref
                        .read(profileEditFormNotifierProvider.notifier)
                        .setStudy(study),
                    decoration: const InputDecoration(
                      labelText: 'Studie',
                      hintText: 'Rechten, Geneeskunde, etc.',
                    ),
                  ),
                  DropdownButtonFormField<String?>(
                    value: user.data().board,
                    onSaved: (value) => ref
                        .read(profileEditFormNotifierProvider.notifier)
                        .setBoard(value),
                    hint: const Text('Welk boord?'),
                    decoration: const InputDecoration(
                      labelText: 'Boord',
                      hintText: 'Welk boord roei je?',
                    ),
                    items:
                        // The boards are Bakboord, Stuurboord, etc.
                        ['Bakboord', 'Stuurboord', 'Scull', 'Multiboord']
                            .map(
                              (board) => DropdownMenuItem<String>(
                                value: board,
                                child: Text(board),
                              ),
                            )
                            .toList(),
                    onChanged: (_) => {},
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
                      ), // in de toekomst willen we niet alleen dat ploegen worden weergegeven, maar ook commissies en andere groepen
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
                      value: user.data().huis,
                      onSaved: (huis) => ref
                          .read(profileEditFormNotifierProvider.notifier)
                          .setHuis(huis),
                      hint: const Text('Geen'),
                      decoration: const InputDecoration(
                        labelText: 'Njord-huis',
                      ),
                      items: ['Geen', ...houseNames]
                          .map(
                            (house) => DropdownMenuItem<String>(
                              value: house,
                              child: Text(house),
                            ),
                          )
                          .toList(),
                      onChanged: (_) => {},
                    ),
                    MultiSelectDialogField<String>(
                      title: const Text('Substructuren'),
                      // ignore: no-equal-arguments
                      buttonText: const Text('Substructuren'),
                      initialValue: user.data().substructures ?? [],
                      onSaved: (substructures) => ref
                          .read(profileEditFormNotifierProvider.notifier)
                          .setSubstructuren(substructures),
                      items: substructures
                          .map(
                            (structure) => MultiSelectItem<String>(
                              structure,
                              // ignore: no-equal-arguments
                              structure,
                            ),
                          )
                          .toList(),
                      onConfirm: (_) => {},
                    ),
                    DropdownButtonFormField<bool?>(
                      value: user.data().dubbellid,
                      onSaved: (dubbellib) => ref
                          .read(profileEditFormNotifierProvider.notifier)
                          .setDubbellid(dubbellib),
                      hint: const Text('Ben je dubbellid?'),
                      decoration: const InputDecoration(
                        labelText: 'Dubbellid',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: true,
                          child: Text('Ja, bij L.S.V. Minerva'),
                        ),
                        DropdownMenuItem(value: false, child: Text('Nee')),
                      ],
                      onChanged: (_) => {},
                    ),
                    TextFormField(
                      initialValue: user.data().otherAssociation,
                      onSaved: (value) => ref
                          .read(profileEditFormNotifierProvider.notifier)
                          .setOtherAssociation(value),
                      decoration: const InputDecoration(
                        labelText: 'Zit je bij een andere vereniging?',
                        hintText: 'L.V.V.S. Augustinus, etc.',
                      ),
                    ),
                  ],
                ),
                // Add a TextFormField for the team the user is in
              ].toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                separator: const SizedBox(height: groupSpacing),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
      ),
      floatingActionButton: // floating action button with save icon
          FloatingActionButton(
        onPressed: submitForm,
        child: const Icon(Icons.save),
      ),
    );
  }

  void submitForm() async {
    // FORM VALIDATION
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sommige velden zijn niet juist ingevuld'),
        ),
      );

      return;
    }
    bool success = true; // on errors set to false
    // Get user id from FirebaseAuth

    // FIND DOCUMENT OF CURRENT USER
    final querySnapshot = await FirebaseFirestore.instance
        .collection('people')
        .withConverter<FirestoreAlmanakProfile>(
          fromFirestore: (snapshot, _) =>
              FirestoreAlmanakProfile.fromFirestore(snapshot.data()!),
          toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
        )
        .where('identifier', isEqualTo: getCurrentUserId())
        .get();

    // SAVE FORM
    _formKey.currentState?.save();

    // UPLOAD FORM TO FIRESTORE
    final ProfileForm form = ref.read(profileEditFormNotifierProvider);
    await querySnapshot.docs.first.reference
        .update(form.toJson())
        .catchError((err) {
      success = false;
    });

    ref.invalidate(firestoreUserFutureProvider); // invalidate cache

    // PROFILE PICTURE UPLOAD
    final File? newprofilePicture = form.profilePicture;
    if (newprofilePicture != null) {
      try {
        CachedProfilePicture.uploadMyProfilePicture(newprofilePicture);
        profilePictureProvider(getCurrentUserId())
            .overrideWith((ref) => Image.file(newprofilePicture).image);
      } on FirebaseException catch (_) {
        success = false;
      }
    }

    // SHOW CONFIRMATION TO USER
    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Je profiel is succesvol gewijzigd'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Er ging iets mis bij het wijzigen van je profiel'),
          ),
        );
      }
    }
  }
}
