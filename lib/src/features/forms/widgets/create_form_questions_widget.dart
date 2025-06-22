import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_filler.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_new_elements_button.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_question.dart';

class CreateFormQuestionsWidget extends ConsumerWidget {
  const CreateFormQuestionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    const sizedBoxHeight = 16.0;
    // Logic for admin vs regular user can go here
    return Column(children: [
      Center(
        child: Text('Vragen', style: Theme.of(context).textTheme.titleLarge),
      ),
      const Divider(
        thickness: 6,
      ),
      const SizedBox(height: sizedBoxHeight),
      ...state.formContentObjectIds.asMap().entries.map((entry) {
        if (state.questions.containsKey(entry.value)) {
          return CreateFormQuestion(
            index: entry.key,
            question: state.questions[entry.value]!,
            onChanged: () => state.updateState(),
            deleteQuestion: (int index) => state.removeQuestion(entry.value),
          );
        } else {
          return CreateFormFiller(
            index: entry.key,
            fillerNotifier:
                state.fillers[entry.value]!, // FirestoreFormFillerNotifier
            deleteFiller: (int index) => state.removeFiller(entry.value),
          );
        }
      }),
      const SizedBox(height: sizedBoxHeight),
      CreateFormNewElementsButton(),
      const SizedBox(height: sizedBoxHeight),
    ]);
  }
}
