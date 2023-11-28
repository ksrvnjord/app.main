import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPage extends ConsumerWidget {
  // Constructor which takes a String formId.
  const FormPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formVal = ref.watch(formProvider(formId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          formVal.when(
            data: (formDoc) {
              if (!formDoc.exists) {
                return const ErrorCardWidget(
                  errorMessage: 'Deze form bestaat niet (meer)',
                );
              }
              // Since the form exists, we can safely assume that the data is not null.
              // ignore: avoid-non-null-assertion
              final FirestoreForm form = formDoc.data()!;

              final bool formIsOpen = DateTime.now().isBefore(form.openUntil);

              const double descriptionVPadding = 16;

              final colorScheme = Theme.of(context).colorScheme;

              final description = form.description;

              final questions = form.questions;

              final textTheme = Theme.of(context).textTheme;

              // ignore: arguments-ordering
              return [
                Text(form.formName, style: textTheme.titleLarge),
                Text(
                  '${formIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
                  style:
                      textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
                if (description != null)
                  Text(description, style: textTheme.bodyMedium)
                      .padding(vertical: descriptionVPadding),
                for (final question in questions) ...[
                  FormQuestion(
                    formQuestion: question,
                    formPath: formDoc.reference.path,
                    form: form,
                    docRef: formDoc.reference,
                  ),
                  const SizedBox(height: 32),
                ],
              ].toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (error, stack) =>
                ErrorCardWidget(errorMessage: error.toString()),
          ),
        ],
      ),
    );
  }
}
