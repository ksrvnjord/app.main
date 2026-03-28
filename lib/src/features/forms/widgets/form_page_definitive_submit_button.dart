import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/ticket_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_ticket.dart';

class FormPageDefinitiveSubmitButton extends ConsumerWidget {
  const FormPageDefinitiveSubmitButton({
    super.key,
    required this.formKey,
    required this.session,
  });

  final GlobalKey<FormState> formKey;
  final FormSession session;

  Future<bool> showConfirmSaveDialog(
      BuildContext context, DocumentReference<FormAnswer> answerDocRef) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool saving = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Bevestigen'),
              content: saving
                  ? const SizedBox(
                      height: 60,
                      child:
                          Center(child: CircularProgressIndicator.adaptive()),
                    )
                  : const Text(
                      'Weet je zeker dat je dit formulier wilt inleveren? Dit kan niet meer worden gewijzigd en eventuele kosten zijn ook definitief.'),
              actions: saving
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annuleren'),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() => saving = true);
                          try {
                            await FormRepository.makeFormAnswerDefinitive(
                                docRef: answerDocRef);

                            FirestoreForm formData = session.formDoc.data()!;

                            if (formData.isLinkedToTicket) {
                              TicketRepository.createTicket(
                                answerDocRef: answerDocRef,
                                ticket: FormTicket(
                                    createdAt:
                                        Timestamp.fromDate(DateTime.now()),
                                    name: session.formDoc.data()!.title,
                                    orginalOwner: session.user.identifierString,
                                    owner: session.user.identifierString,
                                    validFrom:
                                        Timestamp.fromDate(DateTime.now()),
                                    validUntil: Timestamp.fromDate(DateTime(
                                        250,
                                        1,
                                        1)), //TODO must be set dynamically at some point
                                    fromForm: session.formDoc.id,
                                    fromFormAnswer: session.answerDocRef!.id,
                                    status: 'pending'),
                              );
                            }
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          } catch (e) {
                            setState(() => saving = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Fout bij opslaan: $e')),
                              );
                            }
                          }
                        },
                        child: const Text('Bevestigen'),
                      ),
                    ],
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // If session has no answerDocRef yet, nothing to submit
    final answerDocRef = session.answerDocRef;
    if (answerDocRef == null) return const SizedBox.shrink();

    final answerAsync = ref.watch(formAnswerProviderV2(answerDocRef));

    return answerAsync.when(
      data: (answer) {
        return ElevatedButton(
          onPressed: answer.isCompleted
              ? () async {
                  final isValid = formKey.currentState?.validate() ?? false;
                  if (!isValid) return;

                  formKey.currentState?.save();

                  final confirmed =
                      await showConfirmSaveDialog(context, answerDocRef);
                  if (!confirmed || !context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Formulier opgeslagen')),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.save),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Definitief Opslaan${answer.isCompleted ? "" : " (vul eerst alle verplichte vragen in)"}",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stk) => const SizedBox.shrink(),
    );
  }
}
