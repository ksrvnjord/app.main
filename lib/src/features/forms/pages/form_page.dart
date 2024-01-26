import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPage extends ConsumerWidget {
  // Constructor which takes a String formId.
  const FormPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  // ignore: avoid-dynamic
  Future<dynamic> _deleteMyFormAnswer(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final answer = await ref.watch(
      formAnswerProvider(formsCollection.doc(formId)).future,
    );
    if (answer.docs.isNotEmpty) {
      // ignore: avoid-unsafe-collection-methods
      final answerPath = answer.docs.first.reference.path;

      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (innerContext) => AlertDialog(
          title: const Text('Verwijderen'),
          content: const Text(
            'Weet je zeker dat je jouw form-reactie wilt verwijderen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(innerContext).pop(),
              child: const Text('Annuleren'),
            ),
            TextButton(
              // ignore: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected
              onPressed: () async {
                await FormRepository.deleteMyFormAnswer(answerPath);
                // ignore: use_build_context_synchronously
                if (innerContext.mounted) Navigator.of(innerContext).pop(true);
              },
              child: const Text('Verwijderen').textColor(Colors.red),
            ),
          ],
        ),
      );
    }
    throw Exception("Geen antwoord gevonden om te verwijderen");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doc = formsCollection.doc(formId);

    final formVal = ref.watch(formProvider(doc));

    return Scaffold(
      appBar: AppBar(title: const Text('Form')),
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
              final form = formDoc.data()!;

              final formIsOpen =
                  DateTime.now().isBefore(form.openUntil.toDate());

              const descriptionVPadding = 16.0;

              final colorScheme = Theme.of(context).colorScheme;

              final description = form.description;

              final questions = form.questions;

              final textTheme = Theme.of(context).textTheme;

              final formKey = GlobalKey<FormState>();

              const sizedBoxHeight = 32.0;

              return [
                [Text(form.title, style: textTheme.titleLarge)]
                    .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                Text(
                  '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil.toDate())}',
                  style: textTheme.bodySmall?.copyWith(
                    color: formIsOpen ? Colors.green : colorScheme.outline,
                  ),
                ),
                if (description != null)
                  Text(description, style: textTheme.bodyMedium)
                      .padding(vertical: descriptionVPadding),
                const SizedBox(height: sizedBoxHeight),
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
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
            },
            error: (error, stack) =>
                ErrorCardWidget(errorMessage: error.toString()),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ],
      ),
      floatingActionButton: ref.watch(canRemoveFormAnswerProvider(doc)).when(
            data: (canRemove) => canRemove
                ? FloatingActionButton.extended(
                    tooltip: "Verwijder mijn form reactie",
                    foregroundColor:
                        Theme.of(context).colorScheme.onErrorContainer,
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    heroTag: "delete-my-form-answer",
                    // ignore: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected
                    onPressed: () async {
                      final res = await _deleteMyFormAnswer(ref, context);
                      if (res == true) {
                        // ignore: use_build_context_synchronously, avoid-ignoring-return-values
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Jouw formreactie is verwijderd'),
                          ),
                        );
                      } else {
                        // ignore: use_build_context_synchronously, avoid-ignoring-return-values
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Het is niet gelukt jouw formreactie te verwijderen',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Verwijder mijn formreactie"),
                  )
                : const SizedBox.shrink(),
            error: (err, stk) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
    );
  }
}
