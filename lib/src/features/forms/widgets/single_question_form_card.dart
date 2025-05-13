// ignore_for_file: prefer-extracting-function-callbacks, no-magic-string

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_count_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/allergy_warning_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleQuestionFormCard extends ConsumerStatefulWidget {
  // Constructor which takes a String formId.
  const SingleQuestionFormCard({
    super.key,
    required this.formDoc,
    required this.userGroups,
    required this.userIsAdmin,
  });

  final QueryDocumentSnapshot<FirestoreForm> formDoc;
  final Iterable<int> userGroups;
  final bool userIsAdmin;

  @override
  createState() => _SingleQuestionFormCardState();
}

class _SingleQuestionFormCardState
    extends ConsumerState<SingleQuestionFormCard> {
  // Constructor which takes a String formId.

  final _formKey = GlobalKey<FormState>();

  //ignore: avoid-dynamic, prefer-correct-throws
  Future<dynamic> _deleteMyFormAnswer(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final answer = await ref.watch(
      formAnswerProvider(FirestoreForm.firestoreConvert.doc(widget.formDoc.id))
          .future,
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
              child: const Text('Verwijderen').textColor(Colors.red),
            ),
          ],
        ),
      );
    }
    throw Exception("Geen antwoord gevonden om te verwijderen");
  }

  @override
  Widget build(BuildContext context) {
    final doc = FirestoreForm.firestoreConvert.doc(widget.formDoc.id);
    final formData = widget.formDoc.data();

    var isAFormForUser = true;
    final formGroups = formData.visibleForGroups;

    if (formGroups != null) {
      isAFormForUser = false;
      for (final group in widget.userGroups) {
        if (formGroups.contains(group)) {
          isAFormForUser = true;
          break;
        }
      }
    }

    final openUntil = formData.openUntil.toDate();

    final answerCount =
        ref.watch(formAnswerCountProvider(widget.formDoc.reference)).maybeWhen(
              data: (c) => c,
              orElse: () => null,
            );

    final bool? isSoldOut = answerCount == null
        ? null
        : (formData.hasMaximumNumberOfAnswers == true &&
            answerCount >= (formData.maximumNumberOfAnswers ?? 10000));

    final formIsOpen = DateTime.now().isBefore(openUntil);
    final bool isClosed = !formIsOpen || isSoldOut != false;
    final bool isKoco = formData.authorName == "Kookcommissie";

    final userAnswerProvider =
        ref.watch(formAnswerProvider(widget.formDoc.reference));

    final colorScheme = Theme.of(context).colorScheme;

    final textTheme = Theme.of(context).textTheme;

    const hPadding = 8.0;

    const widthDeleteButton = 400.0;

    final descriptionHPadding = 16;

    return (isAFormForUser || widget.userIsAdmin)
        ? ExpansionTile(
            collapsedIconColor: colorScheme.primary,
            title: Text(formData.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSoldOut == true)
                  Text(
                    "Uitverkocht/Volgeboekt",
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.error),
                  )
                else
                  Text(
                    formIsOpen
                        ? "Sluit ${timeago.format(
                            openUntil,
                            locale: 'nl',
                            allowFromNow: true,
                          )}"
                        : "Gesloten op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(openUntil)}",
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.outline),
                  ),
                userAnswerProvider.when(
                  data: (snapshot) => snapshot.docs.isEmpty
                      ? const SizedBox.shrink()
                      : AnswerStatusCard(
                          answerExists: snapshot.docs.isNotEmpty,
                          isCompleted: snapshot.docs.isNotEmpty &&
                              // ignore: avoid-unsafe-collection-methods
                              snapshot.docs.first.data().isCompleted,
                          showIcon: true,
                          textStyle: textTheme.labelLarge,
                        ),
                  error: (err, stack) =>
                      ErrorTextWidget(errorMessage: err.toString()),
                  loading: () => const SizedBox.shrink(),
                ),
              ],
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.center,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent, width: 0),
            ),
            children: [
              if (formData.description != null)
                Text(formData.description!, style: textTheme.bodyMedium)
                    .padding(horizontal: descriptionHPadding.toDouble()),
              if (isKoco)
                GestureDetector(
                  onTap: () => context.pushNamed(
                    'My Allergies',
                  ),
                  child: AllergyWarningCard(
                    sidePadding: hPadding,
                  ),
                ).padding(top: 16.0),
              Form(
                key: _formKey,
                child: [
                  for (final question in formData.questions) ...[
                    FormQuestion(
                      formQuestion: question,
                      form: formData,
                      docRef: widget.formDoc.reference,
                      formIsOpen: !isClosed && isAFormForUser,
                      withoutBorder: true,
                      showAdditionalSaveButton: true,
                    ).padding(horizontal: hPadding),
                    const SizedBox(height: 2),
                  ],
                ].toColumn(),
              ),
              ref.watch(canRemoveFormAnswerProvider(doc)).when(
                    data: (canRemove) => canRemove
                        ? Padding(
                            padding: const EdgeInsets.all(hPadding),
                            // Add space around the button.
                            child: SizedBox(
                              width:
                                  widthDeleteButton, // Adjust the width as needed.
                              child: ElevatedButton(
                                // ignore: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected
                                onPressed: () async {
                                  final res =
                                      await _deleteMyFormAnswer(ref, context);
                                  if (res == true) {
                                    // ignore: use_build_context_synchronously, avoid-ignoring-return-values
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Jouw formreactie is verwijderd'),
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
                                    SizedBox(width: hPadding),
                                    // Add space between the icon and text.
                                    Text("Verwijder mijn formreactie"),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    error: (err, stk) => const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                  ),
            ],
          ).card(
            // Transparant color.
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: colorScheme.primary),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4),
          )
        : const SizedBox.shrink();
  }
}
