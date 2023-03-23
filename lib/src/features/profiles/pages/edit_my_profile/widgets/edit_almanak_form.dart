import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/houses.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/edit_profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/user_id.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

final CollectionReference<AlmanakProfile> people = FirebaseFirestore.instance
    .collection('people')
    .withConverter<AlmanakProfile>(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class EditAlmanakForm extends StatefulWidget {
  const EditAlmanakForm({Key? key}) : super(key: key);

  @override
  createState() => _EditAlmanakFormState();
}

class _EditAlmanakFormState extends State<EditAlmanakForm> {
  final _formKey = GlobalKey<FormState>();

  final AlmanakProfile _formData =
      AlmanakProfile(lidnummer: FirebaseAuth.instance.currentUser!.uid);
  File? newprofilePicture;

  void changeProfilePicture(File file) {
    newprofilePicture = file;
  }

  @override
  Widget build(BuildContext context) {
    const double fieldPadding = 8;

    return FutureWrapper(
      future: getMyFirestoreProfileData(),
      success: (user) => Form(
        key: _formKey,
        child: <Widget>[
          // create a field to enter Field of Study
          Center(
            child: [
              EditProfilePictureWidget(
                onChanged: changeProfilePicture,
              ),
              const Text(
                'Het kan even duren voordat andere mensen je nieuwe '
                'profielfoto zien.',
              ).textColor(Colors.grey),
            ].toColumn(),
          ),
          TextFormField(
            initialValue: user.study,
            onSaved: (value) => _formData.study = value,
            decoration: const InputDecoration(
              labelText: 'Studie',
              hintText: 'Rechten, Geneeskunde, etc.',
            ),
          ).padding(bottom: fieldPadding),

          // Add a TextFormField for the team the user is in
          TextFormField(
            initialValue: user.ploeg,
            onSaved: (value) => _formData.ploeg = value,
            decoration: const InputDecoration(
              labelText: 'Ploeg',
            ),
          ).padding(vertical: fieldPadding),
          DropdownButtonFormField<String?>(
            value: user.board,
            onSaved: (value) => _formData.board = value,
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
          ).padding(vertical: fieldPadding),
          DropdownButtonFormField<String?>(
            value: user.huis,
            onSaved: (value) => _formData.huis =
                value != 'Geen' ? value : null, // allow user to 'deselect' huis
            hint: const Text('Njord-Huis'),
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
          ).padding(vertical: fieldPadding),
          ListTile(
            title: const Text('Wijzig commissies'),
            trailing:
                const Icon(Icons.arrow_forward_ios, color: Colors.lightBlue),
            onTap: () => Routemaster.of(context).push('commissies'),
          ),
          MultiSelectDialogField<String>(
            title: const Text('Substructuren'),
            // ignore: no-equal-arguments
            buttonText: const Text('Substructuren'),
            initialValue: user.substructuren ?? [],
            onSaved: (items) => _formData.substructuren = items,
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
          ).padding(vertical: fieldPadding),
          DropdownButtonFormField<bool?>(
            value: user.dubbellid,
            onSaved: (value) => _formData.dubbellid = value,
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
          ).padding(vertical: fieldPadding),
          TextFormField(
            initialValue: user.otherAssociation,
            onSaved: (value) =>
                _formData.otherAssociation = value == '' ? null : value,
            decoration: const InputDecoration(
              labelText: 'Zit je bij een andere vereniging?',
              hintText: 'L.V.V.S. Augustinus, etc.',
            ),
          ).padding(vertical: fieldPadding),
          [
            ElevatedButton(
              onPressed: submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              child: const Text('Opslaan'),
            ).expanded(),
          ].toRow(),
        ].toColumn(),
      ),
      loading: Container(),
    );
  }

  void submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // show snackbar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sommige velden zijn niet juist ingevuld'),
        ),
      );

      return;
    }
    bool success = true; // on errors set to false
    Object? error;
    // Get user id from FirebaseAuth
    final String userId = getCurrentUserId();

    // query people collection for user with id
    final QuerySnapshot<AlmanakProfile> querySnapshot = await people
        .where('identifier', isEqualTo: userId)
        .get()
        .catchError((err) {
      // show snackbar with error messag
      error = err;
      success = false;

      return err;
    });

    // retrieve document reference from query snapshot
    final DocumentReference<AlmanakProfile> documentReference =
        querySnapshot.docs.first.reference;

    _formKey.currentState?.save();

    await documentReference.update(_formData.toJson()).catchError((err) {
      // show snackbar with error message
      success = false;
      error = err;
    });
    if (!mounted) return;

    if (newprofilePicture != null) {
      try {
        uploadMyProfilePicture(newprofilePicture!);
      } on FirebaseException catch (err) {
        error = err;
        success = false;
      }
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Er ging iets mis bij het wijzigen van je profiel: ${error.toString()}',
        ),
      ));

      return;
    }
    // show snackbar with success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Je profiel is succesvol gewijzigd'),
      ),
    );
  }
}
