import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';

class SingleQuestionFormCardDeleteButton extends ConsumerWidget {
  const SingleQuestionFormCardDeleteButton({super.key, required this.session});

  final FormSession session;

  Future<bool?> _deleteMyFormAnswer(WidgetRef ref, BuildContext context) async {
    final answerDocRef = session.answerDocRef;
    if (answerDocRef == null) return false;

    final answerSnap = await answerDocRef.get();
    if (!answerSnap.exists) {
      return false;
    }

    if (!context.mounted) return false;

    return showDialog<bool>(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: const Text('Verwijderen'),
        content: const Text(
          'Weet je zeker dat je jouw form-reactie wilt verwijderen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(innerContext).pop(false),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () async {
              await FormRepository.deleteMyFormAnswer(answerDocRef.path);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final answerDocRef = session.answerDocRef;

    if (answerDocRef == null) return const SizedBox.shrink();

    return ref.watch(canRemoveFormAnswerProvider(answerDocRef)).when(
          data: (canRemove) {
            if (!canRemove) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    final res = await _deleteMyFormAnswer(ref, context);
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          res == true
                              ? 'Jouw formreactie is verwijderd'
                              : 'Het is niet gelukt jouw formreactie te verwijderen',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text("Verwijder mijn formreactie"),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        );
  }
}
