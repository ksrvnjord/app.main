import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormCard extends ConsumerWidget {
  const FormCard({Key? key, required this.formDoc}) : super(key: key);

  final DocumentSnapshot<FirestoreForm> formDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = formDoc.data();

    if (form == null) {
      return const ErrorCardWidget(
        errorMessage: 'Het is niet gelukt om de form te laden',
      );
    }

    final formIsOpen = DateTime.now().isBefore(form.openUntil);

    final userAnswerProvider = ref.watch(formAnswerProvider(formDoc.reference));

    final colorScheme = Theme.of(context).colorScheme;

    final textTheme = Theme.of(context).textTheme;

    const iconSize = 16.0;
    const trailingWidth = 256.0;

    return ListTile(
      title: Text(form.formName),
      subtitle: Text(
        '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
        style: textTheme.bodySmall
            ?.copyWith(color: formIsOpen ? Colors.green : colorScheme.outline),
      ),
      trailing: SizedBox(
        width: trailingWidth,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          userAnswerProvider.when(
            data: (snapshot) {
              bool formIsAnswered = snapshot.docs.isNotEmpty;

              return Text(
                'Status: ${formIsAnswered ? "Ingevuld" : "Niet ingevuld"}',
                style: textTheme.bodySmall?.copyWith(
                  color: formIsAnswered ? Colors.green : colorScheme.outline,
                ),
              );
            },
            error: (err, stack) => Text('Error: $err'),
            loading: () => const SizedBox(
              width: 12.0,
              height: 12.0,
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          const SizedBox(width: 32.0),
          Icon(
            Icons.arrow_forward_ios,
            size: iconSize,
            color: colorScheme.primary,
          ),
        ]),
      ),
      onTap: () => unawaited(context.pushNamed(
        "Form",
        pathParameters: {"formId": formDoc.reference.id},
        queryParameters: {"v": "2"},
      )),
    ).card(
      // Transparant color.
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
