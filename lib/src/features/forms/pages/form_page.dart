import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/full_form_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPage extends ConsumerWidget {
  // Constructor which takes a String formId.
  const FormPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formVal = ref.watch(formProvider(formId));
    const double cardPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: ListView(
        children: [
          formVal.when(
            data: (formDoc) {
              final FirestoreForm? form = formDoc.data();
              if (form == null) {
                return const ErrorCardWidget(
                  errorMessage: 'Het is niet gelukt om de form te laden',
                );
              }

              final answerStream =
                  ref.watch(formAnswerProvider(formDoc.reference));

              final bool formIsOpen = DateTime.now().isBefore(form.openUntil);

              const double descriptionHPadding = 16;

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
                      .padding(horizontal: descriptionHPadding),
                ...questions.map(
                  (question) => FullFormCard(
                      question: question, formPath: formDoc.reference.path, formDoc: formDoc,),
                ),
                answerStream.when(
                  data: (snapshot) {
                    // final String? answerOfUser = snapshot.size != 0
                    //     ? snapshot.docs.first.data().answers
                    //     : null;

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
              ].toColumn();
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
