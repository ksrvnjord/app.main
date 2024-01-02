import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/delete_form_answer_button.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPage extends ConsumerWidget {
  // Constructor which takes a String formId.
  const FormPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  Future<void> deleteAnswerAndCloseDialog(
    BuildContext context,
    String answerPath,
  ) async {
    await FormRepository.deleteMyFormAnswer(answerPath);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(true);
  }

  Future<bool?> deleteMyFormAnswer(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final answer = await ref.watch(
      formAnswerProvider(formsCollection.doc(formId)).future,
    );
    if (answer.docs.isNotEmpty) {
      final String answerPath = answer.docs.first.reference.path;

      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Verwijderen'),
          content: const Text(
            'Weet je zeker dat je jouw form-reactie wilt verwijderen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () => deleteAnswerAndCloseDialog(
                context,
                answerPath,
              ),
              child: const Text('Verwijderen').textColor(Colors.red),
            ),
          ],
        ),
      );
    } else {
      throw Exception("Geen antwoord gevonden om te verwijderen");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doc = formsCollection.doc(formId);

    final formVal = ref.watch(formProvider(doc));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'), // TODO: Misschien verwijderen.
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          formVal.when(
            data: (formDoc) {
              if (!formDoc.exists) {
                return const ErrorCardWidget(
                  errorMessage: 'Deze form bestaat niet (meer)',
                );
              }
              // Since the form exists, we can safely assume that the data is not null.
              // ignore: avoid-non-null-assertion
              final FirestoreForm form = formDoc.data()!;

              final bool formIsOpen = DateTime.now().isBefore(form.openUntil);

              const double descriptionVPadding = 16;

              final colorScheme = Theme.of(context).colorScheme;

              final description = form.description;

              final questions = form.questions;

              final textTheme = Theme.of(context).textTheme;

              final formKey = GlobalKey<FormState>();

              // ignore: arguments-ordering
              return [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      [
                        Text(form.formName, style: textTheme.titleLarge),
                      ].toRow(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      Text(
                        '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
                        style: textTheme.bodySmall?.copyWith(
                          color:
                              formIsOpen ? Colors.green : colorScheme.outline,
                        ),
                      ),
                      if (description != null)
                        Text(description, style: textTheme.bodyMedium)
                            .padding(vertical: descriptionVPadding),
                    ],
                  ),
                  const Spacer(),
                  DeleteFormAnswerButton(
                    deleteMyFormAnswer: deleteMyFormAnswer,
                    formId: formId,
                    formIsOpen: formIsOpen,
                  ),
                ]),
                Form(
                  key: formKey,
                  child: [
                    for (final question in questions) ...[
                      FormQuestion(
                        formQuestion: question,
                        form: form,
                        docRef: formDoc.reference,
                        formIsOpen: formIsOpen,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ].toColumn(),
                ),
              ].toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
              );
            },
            error: (error, stack) =>
                ErrorCardWidget(errorMessage: error.toString()),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ],
      ),
    );
  }
}
