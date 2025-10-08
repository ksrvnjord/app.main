import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';

class SingleQuestionFormCardDeleteButton extends ConsumerWidget {
  const SingleQuestionFormCardDeleteButton(
      {super.key, required this.reference});
  final DocumentReference<FirestoreForm> reference;

  Future<dynamic> _deleteMyFormAnswer(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final answer = await ref.watch(
      formAnswerProvider(reference).future,
    );
    if (answer.docs.isNotEmpty) {
      // ignore: avoid-unsafe-collection-methods
      final answerPath = answer.docs.first.reference.path;

      if (!context.mounted) return;

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
              child: const Text(
                'Verwijderen',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }
    throw Exception("Geen antwoord gevonden om te verwijderen");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const hPadding = 8.0;
    const widthDeleteButton = 400.0;
    final colorScheme = Theme.of(context).colorScheme;

    return ref.watch(canRemoveFormAnswerProvider(reference)).when(
          data: (canRemove) => canRemove
              ? Padding(
                  padding: const EdgeInsets.all(hPadding),
                  child: SizedBox(
                    width: widthDeleteButton,
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await _deleteMyFormAnswer(ref, context);
                        final snackBar = SnackBar(
                          content: Text(
                            res == true
                                ? 'Jouw formreactie is verwijderd'
                                : 'Het is niet gelukt jouw formreactie te verwijderen',
                          ),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(colorScheme.errorContainer),
                        foregroundColor: WidgetStateProperty.all(
                            colorScheme.onErrorContainer),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: hPadding),
                          Text("Verwijder mijn formreactie"),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        );
  }
}
