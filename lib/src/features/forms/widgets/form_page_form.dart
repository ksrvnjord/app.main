import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_filler.dart';
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

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (form.isV2) ...[
            for (final contentIndex in form.formContentObjectIndices) ...[
              form.questionsV2.containsKey(contentIndex)
                  ? FormQuestion(
                      formQuestion: form.questionsV2[contentIndex]!,
                      form: form,
                      docRef: formDoc.reference,
                      formIsOpen: form.userCanEditForm,
                    )
                  : FormFiller(filler: form.fillers[contentIndex]!),
              const SizedBox(height: 32),
            ]
          ] else ...[
            for (final question in form.questions) ...[
              FormQuestion(
                formQuestion: question,
                form: form,
                docRef: formDoc.reference,
                formIsOpen: form.userCanEditForm,
              ),
              const SizedBox(height: 32),
            ]
          ],
        ],
      ),
    );
  }
}
