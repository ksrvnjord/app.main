import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';

class FormPageForm extends StatelessWidget {
  const FormPageForm({
    super.key,
    required this.formDoc,
    required this.formKey,
  });

  final DocumentSnapshot<FirestoreForm> formDoc;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final form = formDoc.data();

    if (form == null) {
      return const Text('No valid response found!');
    }

    final questions = form.questions;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final question in questions) ...[
            FormQuestion(
              formQuestion: question,
              form: form,
              docRef: formDoc.reference,
              formIsOpen: !form.isClosed,
            ),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}
