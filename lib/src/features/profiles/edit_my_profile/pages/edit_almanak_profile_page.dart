// ignore_for_file: avoid-long-functions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/profile_edit_form_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/edit_profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/houses.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:styled_widget/styled_widget.dart';

class EditAlmanakProfilePage extends ConsumerStatefulWidget {
  const EditAlmanakProfilePage({super.key});

  @override
  createState() => _EditAlmanakProfilePageState();
}

class _EditAlmanakProfilePageState
    extends ConsumerState<EditAlmanakProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentFirestoreUserProvider);
    final userVal =
        ref.watch(firestoreUserStreamProvider(currentUser?.identifier ?? ""));

    // TODO: Make a try-else statement for if the userId is null.

    // ignore: avoid-non-null-assertion
    final userId = ref.watch(firebaseAuthUserProvider).value!.uid;

    const double floatingActionButtonSpacing = 16;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Mijn profiel")),
      body: userVal.when(
        data: (user) => buildForm(
          user,
          context,
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
      ),
      floatingActionButton: // Floating action button with save icon.
          [
        FloatingActionButton.extended(
          backgroundColor: colorScheme.secondaryContainer,
          heroTag: null, // Prevents the hero animation from playing.
          onPressed: () => context.goNamed('Preview Profile', pathParameters: {
            'identifier': userId,
          }),
          label: const Text("Publiek profiel bekijken")
              .textColor(colorScheme.onSecondaryContainer),
        ),
        FloatingActionButton.extended(
          backgroundColor: colorScheme.primaryContainer,
          heroTag: null, // Prevents the hero animation from playing.
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
    QuerySnapshot<FirestoreUser> snapshot,
    BuildContext context,
  ) {
    final user = snapshot.docs.first.data();
    final colorScheme = Theme.of(context).colorScheme;

    const double imageHelpTextTopPadding = 16;
    const double groupSpacing = 16;

    return ListView(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 80),
      children: [
        Form(
          key: _formKey,
          child: <Widget>[
            [
              const EditProfilePictureWidget(),
              Text(
                'Het kan even duren voordat iedereen je nieuwe foto ziet',
                style: Theme.of(context).textTheme.labelSmall,
              ).textAlignment(TextAlign.center),
            ]
                .toColumn(
                  separator: const SizedBox(height: imageHelpTextTopPadding),
                )
                .center(),
            // ignore: avoid-non-ascii-symbols
            FormSection(title: "  Profielinstellingen", children: [
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
              DropdownButtonFormField<String?>(
                items: ['Geen', ...kHouseNames]
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
                selectedColor: colorScheme.primaryContainer,
                backgroundColor: colorScheme.surface,
                checkColor: colorScheme.onPrimaryContainer,
                itemsTextStyle: TextStyle(color: colorScheme.onSurface),
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
              ListTile(
                // ignore: avoid-non-ascii-symbols
                title: const Text('Geef mijn allergieën/aversies door'),
                subtitle: const Text(
                  "De KoCo houdt hier rekening mee als jij je inschrijft voor het eten.",
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  'My Allergies',
                ), // In de toekomst willen we niet alleen dat ploegen worden weergegeven, maar ook commissies en andere groepen.
              ),
              ListTile(
                title: const Text('Bekijk mijn permissies'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  'My Permissions',
                ), // In de toekomst willen we niet alleen dat ploegen worden weergegeven, maar ook commissies en andere groepen.
              ),
              Card(
                color: colorScheme.tertiaryContainer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                margin: const EdgeInsets.all(0.0),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        "Ploegen en commissies worden door het bestuur ingedeeld.",
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
            FormSection(title: "  Persoonsgegevens", children: [
              ListTile(
                title: const Text('Bekijk mijn persoonsgegevens'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  "Sensitive Data",
                ),
              ),
              ListTile(
                title: const Text('Wijzig mijn zichtbaarheid in de app'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed('Edit My Visibility'),
              ),
            ]),
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
    final formState = _formKey.currentState;
    final colorScheme = Theme.of(context).colorScheme;
    // FORM VALIDATION.
    if (formState != null && !formState.validate()) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Sommige velden zijn niet juist ingevuld',
          ).textColor(colorScheme.onErrorContainer),
          backgroundColor: colorScheme.errorContainer,
        ),
      );

      return;
    }
    bool success = true; // On errors set to false.
    final currentUser = ref.watch(currentFirestoreUserProvider);

    // FIND DOCUMENT OF CURRENT USER.
    final querySnapshot = await peopleCollection
        .where('identifier', isEqualTo: currentUser?.identifier ?? "")
        .get();

    formState?.save();

    // UPLOAD FORM TO FIRESTORE.
    final ProfileForm form = ref.read(profileEditFormNotifierProvider);
    await querySnapshot.docs.first.reference
        .update(form.toJson())
        .catchError((err) {
      success = false;
    });

    ref.invalidate(firestoreUserStreamProvider); // Invalidate cache.

    final newprofilePicture = form.profilePicture;
    if (newprofilePicture != null) {
      try {
        // Use XFile directly.
        final imageData = await newprofilePicture.readAsBytes();

        // Upload the picture (assuming CachedProfilePicture.uploadMyProfilePicture can work with Uint8List or XFile).
        CachedProfilePicture.uploadMyProfilePicture(imageData);
        final currentUser = ref.watch(currentFirestoreUserProvider);
        profilePictureProvider(currentUser?.identifier ?? "").overrideWith(
          (ref) => Image.memory(imageData).image,
        );
      } on FirebaseException catch (_) {
        success = false;
      }
    }

    // SHOW CONFIRMATION TO USER.
    if (success) {
      if (mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Je profiel is succesvol gewijzigd'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Er ging iets mis bij het wijzigen van je profiel',
            ).textColor(colorScheme.onErrorContainer),
            backgroundColor: colorScheme.errorContainer,
          ),
        );
      }
    }
  }
}
