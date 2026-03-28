import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class SingleChoiceWidget extends StatelessWidget {
  const SingleChoiceWidget({
    super.key,
    required this.session,
    required this.questionId,
    required this.onChanged,
    required this.userCanEditForm,
  });

  final FormSession session;
  final int questionId;
  final void Function(String?) onChanged;
  final bool userCanEditForm;

  FirestoreFormQuestion _getQuestion() {
    final form = session.formDoc.data()!;
    if (form.isV2) {
      return form.questionsMap[questionId]!;
    } else {
      return form.questions.firstWhere((q) => q.id == questionId);
    }
  }

  String? _getInitialValue() {
    if (session.prefillSnapshot?.docs.isNotEmpty == true) {
      final answers = session.prefillSnapshot!.docs.first.data().answers;
      final question = _getQuestion();

      for (final answer in answers) {
        if (session.formDoc.data()!.isV2) {
          if (answer.questionId == questionId) {
            return answer.answerList?.first;
          }
        } else {
          if (answer.questionTitle == question.title) {
            return answer.answer;
          }
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final question = _getQuestion();
    final options = question.options;
    final initialValue = _getInitialValue();

    if (options == null) {
      return const ErrorCardWidget(
        errorMessage: 'Er zijn geen opties voor deze vraag',
      );
    }

    return Column(
      children: options
          .map(
            (choice) => RadioListTile<String>(
              value: choice,
              groupValue: initialValue,
              onChanged: userCanEditForm ? onChanged : null,
              toggleable: true,
              title: Text(choice),
            ),
          )
          .toList(),
    );
  }
}
