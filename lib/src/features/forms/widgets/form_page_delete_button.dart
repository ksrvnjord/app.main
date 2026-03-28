import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPageDeleteButton extends ConsumerWidget {
  const FormPageDeleteButton({
    super.key,
    required this.session,
    required this.formKey,
  });

  final FormSession session;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final answerDocRef = session.answerDocRef;

    // 🔴 Centralized null handling
    if (answerDocRef == null) {
      return ErrorCardWidget(
        errorMessage: 'Sessie bevat geen aanwezige formreferentie. ',
      );
    }

    // Now safe to use answerDocRef everywhere
    final canRemoveFormAnswerVal =
        ref.watch(canRemoveFormAnswerProvider(answerDocRef));

    return canRemoveFormAnswerVal.when(
      data: (canRemove) {
        if (!canRemove) return const SizedBox.shrink();

        return ElevatedButton(
          onPressed: () async {
            final res = await _deleteFormAnswer(ref, context, answerDocRef);
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
                child: Text(
                  "Verwijder mijn formreactie",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      error: (err, stk) => ErrorTextWidget(errorMessage: err.toString()),
      loading: () => const SizedBox.shrink(),
    );
  }
}

Future<bool?> _deleteFormAnswer(
  WidgetRef ref,
  BuildContext context,
  DocumentReference answerRef,
) async {
  final answerSnap = await answerRef.get();
  if (!answerSnap.exists) return false;

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
            await FormRepository.deleteMyFormAnswer(answerRef.path);
            await deleteAllImages(answerRef.id, ref);
            if (innerContext.mounted) {
              Navigator.of(innerContext).pop(true);
            }
          },
          child: const Text('Verwijderen').textColor(Colors.red),
        ),
      ],
    ),
  );
}
