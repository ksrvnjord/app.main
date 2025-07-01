import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_question.dart';

class CreateFormQuestionsWidget extends ConsumerWidget {
  const CreateFormQuestionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    const sizedBoxHeight = 16.0;
    const sizedBoxWidthButton = 256.0;
    // Logic for admin vs regular user can go here
    return Column(children: [
      Center(
        child: Text('Vragen', style: Theme.of(context).textTheme.titleLarge),
      ),
      const Divider(
        thickness: 6,
      ),
      const SizedBox(height: sizedBoxHeight),
      ...state.questions.asMap().entries.map((questionEntry) {
        return CreateFormQuestion(
          index: questionEntry.key,
          question: questionEntry.value,
          onChanged: () => state.updateState(),
          deleteQuestion: (int index) => state.removeQuestion(index),
        );
      }),
      const SizedBox(height: sizedBoxHeight),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            width: sizedBoxWidthButton,
            child: ElevatedButton(
              onPressed: () => state.addQuestion(FirestoreFormQuestion(
                title: '',
                type: FormQuestionType.text,
                isRequired: true,
                options: [],
              )), // Add an empty label for the new TextFormField.

              child: const Text('Voeg vraag toe aan form'),
            ),
          ),
          const Spacer(),
        ],
      ),
      const SizedBox(height: sizedBoxHeight),
    ]);
  }
}
