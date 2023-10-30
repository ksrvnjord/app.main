import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/upsert_form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FullFormCard extends ConsumerWidget {
  const FullFormCard({
    Key? key,
    required this.formDoc,
  }) : super(key: key);

  final DocumentSnapshot<FirestoreForm> formDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreForm? form = formDoc.data();
    if (form == null) {
      return const ErrorCardWidget(
        errorMessage: 'Het is niet gelukt om de form te laden',
      );
    }

    final answerStream = ref.watch(formAnswerProvider(formDoc.reference));

    final bool formIsOpen = DateTime.now().isBefore(form.openUntil);

    final bool pollIsOpen = DateTime.now().isBefore(form.openUntil);

    const double descriptionHPadding = 16;

    final colorScheme = Theme.of(context).colorScheme;

    final description = form.description;

    final questions = form.questions;

    final textTheme = Theme.of(context).textTheme;

    // ignore: arguments-ordering
    return ExpansionTile(
      title: Text(form.formName),
      subtitle: Text(
        '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
        style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
      ),
      initiallyExpanded: true,
      // ignore: avoid-non-null-assertion
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
      ),
      children: [
        if (description != null)
          Text(description, style: textTheme.bodyMedium)
              .padding(horizontal: descriptionHPadding),
        questions
            .map(
              (question) =>
                  Text(question['Label'], style: textTheme.bodyMedium),
            )
            .toList()
            .toColumn(),
        answerStream.when(
          data: (snapshot) {
            final String? answerOfUser =
                snapshot.size != 0 ? snapshot.docs.first.data().answer : null;

            return Container();
            // return [
            //   ...form.questions.map((option) => RadioListTile(
            //         value: option,
            //         groupValue: answerOfUser,
            //         toggleable: true,
            //         title: Text(option),
            //       )),
            // ].toColumn();
          },
          error: (error, stackTrace) => const ErrorCardWidget(
            errorMessage: 'Het is mislukt om je antwoord te laden',
          ),
          loading: () => const CircularProgressIndicator.adaptive(),
        ),
      ],
    ).card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      // Transparant color.
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
