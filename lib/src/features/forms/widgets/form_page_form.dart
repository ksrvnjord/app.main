import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_filler.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';

class FormPageForm extends StatelessWidget {
  const FormPageForm({
    super.key,
    required this.session,
    required this.formKey,
    required this.isAFormForUser,
  });

  final FormSession session;
  final GlobalKey<FormState> formKey;
  final bool isAFormForUser;

  @override
  Widget build(BuildContext context) {
    final form = session.formDoc.data();
    if (form == null) return const Text('No valid response found!');

    final answerIsDefinitive = session.prefillSnapshot?.docs.isNotEmpty == true
        ? session.prefillSnapshot!.docs.first
            .data()
            .definitiveAnswerHasBeenGiven
        : false;

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
                      session: session, // <-- pass full session
                      questionId: contentIndex,
                      formQuestion: form.questionsMap[contentIndex]!,
                      userCanEditForm:
                          form.isOpen && isAFormForUser && !answerIsDefinitive,
                    )
                  : FormFiller(
                      session: session, // <-- pass full session
                      filler: form.fillers[contentIndex]!.value,
                    ),
              const SizedBox(height: 32),
            ]
          ] else ...[
            for (final question in form.questions) ...[
              FormQuestion(
                session: session, // <-- pass full session
                questionId: question.id,
                formQuestion: question,
                userCanEditForm:
                    form.isOpen && isAFormForUser && !answerIsDefinitive,
              ),
              const SizedBox(height: 32),
            ]
          ],
        ],
      ),
    );
  }
}
