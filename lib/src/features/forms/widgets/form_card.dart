import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormCard extends ConsumerWidget {
  const FormCard({
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

    final bool formIsOpen = DateTime.now().isBefore(form.openUntil);

    final colorScheme = Theme.of(context).colorScheme;

    final textTheme = Theme.of(context).textTheme;

    // ignore: arguments-ordering
    return ListTile(
      title: Text(form.formName),
      subtitle: Text(
        '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
        style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
      ),
      // ignore: avoid-non-null-assertion
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: colorScheme.primary,
      ),
      onTap: () => context.pushNamed(
        "Form",
        pathParameters: {
          "formId": formDoc.reference.id,
        },
        queryParameters: {"v": "2"}, // TODO: Remove this after migration.
      ),
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
