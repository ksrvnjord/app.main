import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';

class DateChoiceWidget extends ConsumerWidget {
  const DateChoiceWidget({
    super.key,
    required this.session,
    required this.questionId,
    required this.userCanEditForm,
    required this.onChanged,
  });

  final FormSession session;
  final int questionId;
  final bool userCanEditForm;
  final void Function(String?) onChanged;

  DateTime? _getCurrentAnswer() {
    if (session.prefillSnapshot?.docs.isNotEmpty == true) {
      final answers = session.prefillSnapshot!.docs.first.data().answers;
      for (final answer in answers) {
        if (session.formDoc.data()!.isV2) {
          if (answer.questionId == questionId) {
            if (answer.answerList != null && answer.answerList!.isNotEmpty) {
              return DateTime.tryParse(answer.answerList!.first);
            }
          }
        } else {
          if (answer.questionTitle ==
              session.formDoc
                  .data()!
                  .questions
                  .firstWhere((q) => q.id == questionId)
                  .title) {
            return DateTime.tryParse(answer.answer ?? '');
          }
        }
      }
    }
    return null;
  }

  FirestoreFormQuestion _getQuestion() {
    final form = session.formDoc.data()!;
    if (form.isV2) {
      return form.questionsMap[questionId]!;
    } else {
      return form.questions.firstWhere((q) => q.id == questionId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final question = _getQuestion();
    final startDate = question.startDate!;
    final endDate = question.endDate!;

    final initialDate =
        DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate)
            ? DateTime.now()
            : (DateTime.now().isBefore(startDate) ? startDate : endDate);

    final currentAnswer = _getCurrentAnswer();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: userCanEditForm
            ? () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentAnswer ?? initialDate,
                  firstDate: startDate,
                  lastDate: endDate,
                );
                if (selectedDate != null) {
                  // Save the new answer
                  await FormRepository.upsertFormAnswer(
                    question: question.title,
                    questionId: questionId,
                    newValue: [selectedDate.toIso8601String()],
                    form: session.formDoc.data()!,
                    docRef: session.formDoc.reference,
                    ref: ref,
                  );

                  onChanged(selectedDate.toIso8601String());
                }
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: colorScheme.primary),
              const SizedBox(width: 8.0),
              Text(
                currentAnswer != null
                    ? currentAnswer.toString().split(' ')[0]
                    : 'Selecteer een datum',
                style: textTheme.bodyLarge
                    ?.copyWith(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
