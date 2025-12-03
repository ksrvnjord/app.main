import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPageDeleteButton extends ConsumerWidget {
  const FormPageDeleteButton({
    super.key,
    required this.doc,
    required this.formId,
    required this.formKey,
  });

  final DocumentReference<FirestoreForm> doc;
  final String formId;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final canRemoveFormAnswerVal = ref.watch(canRemoveFormAnswerProvider(doc));

    return canRemoveFormAnswerVal.when(
        data: (canRemove) {
          if (!canRemove) return const SizedBox.shrink();

          return ElevatedButton(
            // ignore: avoid-passing-async-when-sync-expected
            onPressed: () async {
              final res = await _deleteMyFormAnswer(ref, context, formId);
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
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                colorScheme.errorContainer,
              ),
              foregroundColor: WidgetStateProperty.all(
                colorScheme.onErrorContainer,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete),
                SizedBox(width: 8),
                Flexible(
                  child: Text("Verwijder mijn formreactie",
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          );
        },
        error: (err, stk) => ErrorTextWidget(errorMessage: err.toString()),
        loading: () => const SizedBox.shrink());
  }

  // This function can optionally be lifted to a shared service if used elsewhere
  Future<bool?> _deleteMyFormAnswer(
    WidgetRef ref,
    BuildContext context,
    String formId,
  ) async {
    final answerSnapshot = await ref.watch(
        formAnswerProvider(FirestoreForm.firestoreConvert.doc(formId)).future);

    if (answerSnapshot.docs.isEmpty) {
      return false;
    }

    final answerPath = answerSnapshot.docs.first.reference.path;

    return showDialog<bool>(
      // ignore: use_build_context_synchronously
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
              await FormRepository.deleteMyFormAnswer(answerPath);
              await deleteAllImages(formId, ref);
              if (innerContext.mounted) Navigator.of(innerContext).pop(true);
            },
            child: const Text('Verwijderen').textColor(Colors.red),
          ),
        ],
      ),
    );
  }
}
