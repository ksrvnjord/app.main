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
    required this.isAFormForUser,
  });

  final DocumentSnapshot<FirestoreForm> formDoc;
  final GlobalKey<FormState> formKey;
  final bool isAFormForUser;

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
            for (final contentIndex in form.formContentObjectIds) ...[
              form.questionsMap.containsKey(contentIndex)
                  ? FormQuestion(
                      formQuestion: form.questionsMap[contentIndex]!,
                      questionId: contentIndex,
                      form: form,
                      docRef: formDoc.reference,
                      userCanEditForm: form.isOpen && isAFormForUser,
                    )
                  : FormFiller(
                      filler: form.fillers[contentIndex]!.value,
                      formId: formDoc.id,
                    ),
              const SizedBox(height: 32),
            ]
          ] else ...[
            for (final question in form.questions) ...[
              FormQuestion(
                formQuestion: question,
                form: form,
                docRef: formDoc.reference,
                userCanEditForm: form.isOpen && isAFormForUser,
              ),
              const SizedBox(height: 32),
            ]
          ],
        ],
      ),
    );
  }
}
