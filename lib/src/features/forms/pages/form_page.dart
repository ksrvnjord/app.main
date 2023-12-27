import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPage extends ConsumerWidget {
  // Constructor which takes a String formId.
  const FormPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  Future<dynamic> deleteMyFormAnswer(
      WidgetRef ref, BuildContext context) async {
    final answer = await ref.watch(
      formAnswerProvider(FirebaseFirestore.instance.doc('forms/$formId'))
          .future,
    );
    if (answer.docs.isNotEmpty) {
      final String answerPath = answer.docs.first.reference.path;

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
              onPressed: () async {
                await FormRepository.deleteMyFormAnswer(answerPath);
                Navigator.of(context).pop(true);
              },
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
    final formVal = ref.watch(formProvider(formId));

    final FirestoreForm? form = formVal.value?.data();

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

              // ignore: arguments-ordering
              return [
                [
                  Text(form.formName, style: textTheme.titleLarge),
                ].toRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Text(
                  '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
                  style:
                      textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
                if (description != null)
                  Text(description, style: textTheme.bodyMedium)
                      .padding(vertical: descriptionVPadding),
                for (final question in questions) ...[
                  FormQuestion(
                    formQuestion: question,
                    formPath: formDoc.reference.path,
                    form: form,
                    docRef: formDoc.reference,
                  ),
                  const SizedBox(height: 32),
                ],
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
      floatingActionButton: ref
          .watch(formAnswerProvider(
            FirebaseFirestore.instance.doc('forms/$formId'),
          ))
          .when(
            data: (snapshot) => snapshot.size == 0
                ? const SizedBox.shrink()
                : FloatingActionButton.extended(
                    foregroundColor:
                        Theme.of(context).colorScheme.onErrorContainer,
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    heroTag: "delete-my-form-answer",
                    // ignore: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected
                    onPressed: () async {
                      final res = await deleteMyFormAnswer(ref, context);
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
                  ),
            error: (err, stk) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
    );
  }
}
