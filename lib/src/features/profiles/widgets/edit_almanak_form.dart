import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/user_id.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
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
      success: (data) => Form(
        key: _formKey,
        child: <Widget>[
          // create a field to enter Field of Study
          TextFormField(
            initialValue: data.study,
            onSaved: (value) => _formData.study = value,
            decoration: const InputDecoration(
              labelText: 'Wat studeer je?',
              hintText: 'Rechten, Geneeskunde, etc.',
            ),
          ).padding(bottom: fieldPadding),
          DropdownButtonFormField<String?>(
            value: data.board,
            onSaved: (value) => _formData.board = value,
            hint: const Text('Welk boord?'),
            decoration: const InputDecoration(
              labelText: 'Boord',
              hintText: 'Welk boord?',
            ),
            items: const [
              DropdownMenuItem(value: 'Bakboord', child: Text('Bakboord')),
              DropdownMenuItem(value: 'Stuurboord', child: Text('Stuurboord')),
              DropdownMenuItem(value: 'Scull', child: Text('Scull')),
              DropdownMenuItem(value: 'Multiboord', child: Text('Multiboord')),
            ],
            onChanged: (_) => {},
          ).padding(vertical: fieldPadding),
          // Add a TextFormField for the team the user is in
          TextFormField(
            initialValue: data.ploeg,
            onSaved: (value) => _formData.ploeg = value,
            decoration: const InputDecoration(
              labelText: 'In welke ploeg zit je?',
            ),
          ).padding(vertical: fieldPadding),
          DropdownButtonFormField<bool?>(
            value: data.dubbellid,
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
            initialValue: data.otherAssociation,
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
    // Use Firestore to save the data
    // create reference to 'people' collection
    final CollectionReference people =
        FirebaseFirestore.instance.collection('people');

    // Get user id from FirebaseAuth
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    // query people collection for user with id
    final QuerySnapshot querySnapshot = await people
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
    final DocumentReference documentReference =
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
