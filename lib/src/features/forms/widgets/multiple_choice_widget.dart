import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';

class MultipleChoiceWidget extends StatelessWidget {
  const MultipleChoiceWidget({
    super.key,
    required this.session,
    required this.questionId,
    required this.onChanged,
    required this.userCanEditForm,
  });

  final FormSession session;
  final int questionId;
  final void Function(List<String>) onChanged;
  final bool userCanEditForm;

  FirestoreFormQuestion _getQuestion() {
    final form = session.formDoc.data()!;
    if (form.isV2) {
      return form.questionsMap[questionId]!;
    } else {
      return form.questions.firstWhere((q) => q.id == questionId);
    }
  }

  List<String> _getInitialValues() {
    if (session.prefillSnapshot?.docs.isNotEmpty == true) {
      final answers = session.prefillSnapshot!.docs.first.data().answers;
      final question = _getQuestion();
      for (final answer in answers) {
        if (session.formDoc.data()!.isV2) {
          if (answer.questionId == questionId) {
            return answer.answerList ?? [];
          }
        } else {
          if (answer.questionTitle == question.title) {
            return [answer.answer ?? ''];
          }
        }
      }
    }
    return [];
  }

  void _toggleSelection(String choice, Set<String> selectedChoices) {
    if (selectedChoices.contains(choice)) {
      selectedChoices.remove(choice);
    } else {
      selectedChoices.add(choice);
    }
    onChanged(selectedChoices.toList());
  }

  @override
  Widget build(BuildContext context) {
    final question = _getQuestion();
    final options = question.options;
    final selectedChoices = _getInitialValues().toSet();

    if (options == null) {
      return const Text('Er zijn geen opties voor deze vraag');
    }

    return Column(
      children: options.map((choice) {
        return CheckboxListTile(
          title: Text(choice),
          value: selectedChoices.contains(choice),
          onChanged: userCanEditForm
              ? (_) => _toggleSelection(choice, selectedChoices)
              : null,
        );
      }).toList(),
    );
  }
}
