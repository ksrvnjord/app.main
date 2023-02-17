import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/data/commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/houses.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/user_id.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
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

  final AlmanakProfile _formData = AlmanakProfile();

  Future<AlmanakProfile> getMyFirestoreProfileData() async {
    String userId = getCurrentUserId();
    QuerySnapshot<AlmanakProfile> profile = await people
        .where('identifier', isEqualTo: userId)
        .get()
        .catchError((error) {
      // show snackbar with error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Er ging iets mis: $error'),
      ));

      return error;
    });

    return profile.docs.first.data();
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
          TextFormField(
            initialValue: user.study,
            onSaved: (value) => _formData.study = value,
            decoration: const InputDecoration(
              labelText: 'Wat studeer je?',
              hintText: 'Rechten, Geneeskunde, etc.',
            ),
          ).padding(bottom: fieldPadding),
          DropdownButtonFormField<String?>(
            value: user.board,
            onSaved: (value) => _formData.board = value,
            hint: const Text('Welk boord?'),
            decoration: const InputDecoration(
              labelText: 'Boord',
              hintText: 'Welk boord?',
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
          // Add a TextFormField for the team the user is in
          TextFormField(
            initialValue: user.ploeg,
            onSaved: (value) => _formData.ploeg = value,
            decoration: const InputDecoration(
              labelText: 'In welke ploeg zit je?',
            ),
          ).padding(vertical: fieldPadding),
          MultiSelectDialogField<String>(
            title: const Text('Commissies'),
            buttonText: const Text('Welke commissies doe je?'),
            searchHint: "Appcommissie, etc.",
            searchable: true,
            separateSelectedItems: true,
            initialValue: user.commissies ?? [],
            onSaved: (items) => _formData.commissies = items,
            items: commissieEmailMap.keys
                .map(
                  (commissie) => MultiSelectItem<String>(
                    commissie,
                    // ignore: no-equal-arguments
                    commissie,
                  ),
                )
                .toList(),
            onConfirm: (_) => {},
          ).padding(vertical: fieldPadding),
          DropdownButtonFormField<String?>(
            value: user.huis,
            onSaved: (value) => _formData.huis = value,
            hint: const Text('In welk Njord-huis zit je?'),
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
          MultiSelectDialogField<String>(
            title: const Text('Substructuren'),
            buttonText: const Text('Bij welke substructuren zit je?'),
            initialValue: user.commissies ?? [],
            onSaved: (items) => _formData.commissies = items,
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
            onSaved: (value) => _formData.otherAssociation = value,
            decoration: const InputDecoration(
              labelText: 'Zit je bij een andere vereniging?',
              hintText: 'L.V.V.S. Augustinus, etc.',
            ),
          ).padding(vertical: fieldPadding),
          ElevatedButton(
            onPressed: submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            child: const Text('Opslaan'),
          ),
        ].toColumn(),
      ),
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

    // Get user id from FirebaseAuth
    final String userId = getCurrentUserId();

    // query people collection for user with id
    final QuerySnapshot<AlmanakProfile> querySnapshot = await people
        .where('identifier', isEqualTo: userId)
        .get()
        .catchError((error) {
      // show snackbar with error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Er ging iets mis: $error'),
      ));

      return error;
    });

    // retrieve document reference from query snapshot
    final DocumentReference<AlmanakProfile> documentReference =
        querySnapshot.docs.first.reference;

    _formKey.currentState?.save();

    await documentReference.update(_formData.toJson()).catchError((error) {
      // show snackbar with error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Er ging iets mis: $error'),
      ));
    });
    if (!mounted) return;

    // show snackbar with success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Je profiel is succesvol gewijzigd'),
      ),
    );
  }
}
