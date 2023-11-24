import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/upsert_form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:styled_widget/styled_widget.dart';

// ignore: prefer-static-class
Widget multipleChoiceWidget({
  String? value, // Given answer
  required Map<String, dynamic> questionMap,
  required DocumentSnapshot<FirestoreForm> formDoc,
  required WidgetRef ref,
  // String formPath,
}) {
  return <Widget>[
    ...questionMap['Choices'].map((choice) => RadioListTile<String>(
          value: choice,
          groupValue: null,
          onChanged: (String? choice) {
            // TODO: questionMap type
            upsertFormAnswer(choice, questionMap['Label'], formDoc, ref);
          },
          toggleable: true,
          title: Text(choice),
        )),
  ].toColumn();
}
