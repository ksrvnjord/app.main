import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class EditAlmanakForm extends StatefulWidget {
  const EditAlmanakForm({Key? key}) : super(key: key);

  @override
  createState() => _EditAlmanakFormState();
}

class _EditAlmanakFormState extends State<EditAlmanakForm> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _formData =
      {}; // we will use this to store the form data

  @override
  Widget build(BuildContext context) {
    const double fieldPadding = 8;

    return Form(
      key: _formKey,
      child: <Widget>[
        // create a field to enter Field of Study
        TextFormField(
          onSaved: (value) => _formData['study'] = value!,
          decoration: const InputDecoration(
            labelText: 'Wat studeer je?',
            hintText: 'Rechten, Geneeskunde, etc.',
          ),
        ),
        DropdownButtonFormField(
          onSaved: (value) => _formData['board'] = value!,
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
        // Add button to submit form
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

    await documentReference.update(_formData).catchError((error) {
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
