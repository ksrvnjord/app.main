import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/firestorm_filler_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_filler.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';

class CreateFormNewElementsButton extends ConsumerWidget {
  const CreateFormNewElementsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    const sizedBoxWidthButton = 180.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: sizedBoxWidthButton,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ElevatedButton(
            onPressed: () => state.addQuestion(
              FirestoreFormQuestion(
                title: '',
                type: FormQuestionType.text,
                isRequired: true,
                options: [],
                id: state.formContentObjectIds
                        .fold<int>(0, (a, b) => a > b ? a : b) +
                    1,
              ),
            ),
            child: const Text('Voeg vraag toe'),
          ),
        ),
        Container(
          width: sizedBoxWidthButton,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ElevatedButton(
            onPressed: () => state.addFiller(
              FirestoreFormFillerNotifier(
                FirestoreFormFiller(
                  title: '',
                  body: '',
                  hasImage: false,
                  id: state.formContentObjectIds
                          .fold<int>(0, (a, b) => a > b ? a : b) +
                      1,
                ),
              ),
            ),
            child: const Text('Voeg info-blok toe'),
          ),
        ),
      ],
    );
  }
}
