// ignore_for_file: prefer-extracting-function-callbacks

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_count_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/allergy_warning_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/routing_constants.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPage extends ConsumerStatefulWidget {
  // Constructor which takes a String formId.
  const FormPage({super.key, required this.formId});

  final String formId;

  @override
  createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  // Constructor which takes a String formId.

  final _formKey = GlobalKey<FormState>();

  // ignore: avoid-dynamic
  Future<dynamic> _deleteMyFormAnswer(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final answer = await ref.watch(
      formAnswerProvider(FirestoreForm.firestoreConvert.doc(widget.formId))
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
                await deleteAllImages(widget.formId, ref);
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

  /// This method is used to unfocus the current form field when the user taps outside of it.
  /// This is useful in cases where the keyboard should be dismissed.
  void _handleTapOutsidePrimaryFocus() {
    final focus = FocusManager.instance.primaryFocus;
    // Guard clause: if there's no focus or it doesn't have primary focus, return early.
    if (focus == null || !focus.hasPrimaryFocus) {
      return;
    }
    // Unfocus the current form field.
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final doc = FirestoreForm.firestoreConvert.doc(widget.formId);
    final colorScheme = Theme.of(context).colorScheme;

    final formVal = ref.watch(formProvider(doc));

    final currentUserVal = ref.watch(currentUserProvider);

    final Iterable<int> userGroups = currentUserVal.when(
      data: (currentUser) {
        return currentUser.groups.map((group) => group.group.id!).toList();
      },
      error: (e, s) {
        // ignore: avoid-async-call-in-sync-function
        FirebaseCrashlytics.instance.recordError(e, s);

        return const [];
      },
      loading: () => const [],
    );

    // ignore: arguments-ordering
    return GestureDetector(
      onTap: _handleTapOutsidePrimaryFocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form'),
          actions: [
            IconButton(
              // ignore: prefer-extracting-callbacks
              onPressed: () {
                const snackbar = SnackBar(
                  content: Text(
                    'Er is iets misgegaan bij het delen van de form',
                  ),
                );
                final routeInformation =
                    GoRouter.of(context).routeInformationProvider.value;

                final state = routeInformation.state as Map<Object?, Object?>?;
                if (state == null) {
                  // ignore: avoid-ignoring-return-values
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);

                  return;
                }
                final imperativeMatches = state['imperativeMatches'] as List?;
                if (imperativeMatches == null || imperativeMatches.isEmpty) {
                  // ignore: avoid-ignoring-return-values
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);

                  return;
                }
                final currentPath =
                    imperativeMatches.firstOrNull['location'] as String;

                const prefixPath = RoutingConstants.appBaseUrl;
                final url = "$prefixPath$currentPath";
                Share.share(url).ignore();
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: ListView(
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 64),
          children: [
            formVal.when(
              data: (formDoc) {
                if (!formDoc.exists) {
                  return const ErrorCardWidget(
                    errorMessage: 'Deze form bestaat niet (meer)',
                  );
                }

                final form = formDoc.data()!;
                final openUntil = form.openUntil.toDate();
                final formIsOpen = DateTime.now().isBefore(openUntil);
                const descriptionVPadding = 16.0;
                final description = form.description;
                final bool isKoco = form.authorName == "Kookcommissie";

                final questions = form.questions;
                final formGroups = form.visibleForGroups;
                final textTheme = Theme.of(context).textTheme;
                final answerVal =
                    ref.watch(formAnswerProvider(formDoc.reference));
                // TODO: van this not be a var?
                bool isAFormForUser = true;
                if (formGroups != null) {
                  isAFormForUser = false;
                  for (final group in userGroups) {
                    if (formGroups.contains(group)) {
                      isAFormForUser = true;
                      break;
                    }
                  }
                }
                final answerCountVal =
                    ref.watch(formAnswerCountProvider(formDoc.reference));

                return answerCountVal.when(
                  data: (answerCount) {
                    final isSoldOut = form.hasMaximumNumberOfAnswers == true &&
                        answerCount >=
                            (form.maximumNumberOfAnswers ??
                                10000); // very high number to represent infinity

                    return [
                      [
                        Flexible(
                          child: Text(form.title, style: textTheme.titleLarge),
                        ),
                      ].toRow(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      Text(
                        '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(openUntil)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: formIsOpen
                              ? colorScheme.secondary
                              : colorScheme.outline,
                        ),
                      ).alignment(Alignment.centerLeft),
                      if (isSoldOut)
                        Text(
                          "Deze form heeft het maximale aantal antwoorden bereikt",
                          style: TextStyle(color: colorScheme.error),
                        ).alignment(Alignment.centerLeft),
                      if (description != null)
                        Text(description, style: textTheme.bodyMedium)
                            .padding(vertical: descriptionVPadding)
                            .alignment(Alignment.centerLeft),
                      if (isKoco)
                        GestureDetector(
                          onTap: () => context.pushNamed(
                            'My Allergies',
                          ),
                          child: AllergyWarningCard(),
                        ),
                      answerVal.when(
                        data: (answer) {
                          final answerExists = answer.docs.isNotEmpty;
                          final answerIsCompleted = answerExists &&
                              // ignore: avoid-unsafe-collection-methods
                              answer.docs.first.data().isCompleted;

                          const leftCardPadding = 8.0;
                          // Move isAllowedToEdit calculation here
                          final isAllowedToEdit = formIsOpen &&
                              (!isSoldOut || answerIsCompleted) &&
                              isAFormForUser;

                          return Column(
                            // Move all child widgets to the left.
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Je hebt deze form ",
                                    style: textTheme.titleMedium,
                                  ),
                                  AnswerStatusCard(
                                    answerExists: answerExists,
                                    isCompleted: answerIsCompleted,
                                    showIcon: false,
                                    textStyle: textTheme.titleMedium,
                                  ).padding(left: leftCardPadding),
                                ],
                              ),
                              if (answerExists && !answerIsCompleted)
                                Text(
                                  "Vul alle verplichte vragen in om je antwoord te versturen.",
                                  style: TextStyle(color: colorScheme.error),
                                ),
                              const SizedBox(height: 32.0),
                              Form(
                                key: _formKey,
                                child: [
                                  for (final question in questions) ...[
                                    FormQuestion(
                                      formQuestion: question,
                                      form: form,
                                      docRef: formDoc.reference,
                                      formIsOpen: isAllowedToEdit,
                                    ),
                                    const SizedBox(height: 32.0),
                                  ],
                                ].toColumn(),
                              ),
                            ],
                          );
                        },
                        error: (error, stack) =>
                            ErrorCardWidget(errorMessage: error.toString()),
                        loading: () => const SizedBox.shrink(),
                      ),
                    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
                  },
                  error: (error, stack) =>
                      ErrorCardWidget(errorMessage: error.toString()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                );
              },
              error: (error, stack) =>
                  ErrorCardWidget(errorMessage: error.toString()),
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
            ref.watch(canRemoveFormAnswerProvider(doc)).when(
                  data: (canRemove) => canRemove
                      ? ElevatedButton(
                          // ignore: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected
                          onPressed: () async {
                            final res = await _deleteMyFormAnswer(ref, context);
                            if (res == true) {
                              // ignore: use_build_context_synchronously, avoid-ignoring-return-values
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Jouw formreactie is verwijderd'),
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
                              Text("Verwijder mijn formreactie"),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  error: (err, stk) =>
                      ErrorTextWidget(errorMessage: err.toString()),
                  loading: () => const SizedBox.shrink(),
                ),
          ],
        ),
      ),
    );
  }
}
