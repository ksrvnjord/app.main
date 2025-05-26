import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/allergy_warning_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_header.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPageBody extends ConsumerWidget {
  const FormPageBody({required this.formDoc, super.key});
  final DocumentSnapshot<FirestoreForm> formDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = formDoc.data()!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final answerVal = ref.watch(formAnswerProvider(formDoc.reference));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormPageHeader(
            form: form, textTheme: textTheme, colorScheme: colorScheme),
        if (form.description != null)
          Text(form.description!, style: textTheme.bodyMedium)
              .padding(vertical: 16),
        if (form.isKoco)
          GestureDetector(
            onTap: () => context.pushNamed('My Allergies'),
            child: const AllergyWarningCard(),
          ),
        answerVal.when(
          data: (answer) =>
              FormAnswerSection(answer: answer, form: form, formDoc: formDoc),
          error: (err, _) => ErrorCardWidget(errorMessage: err.toString()),
          loading: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
