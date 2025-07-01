import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/allergy_warning_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card_delete_button.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:styled_widget/styled_widget.dart';

class SingleQuestionFormCardExpandedArea extends ConsumerWidget {
  const SingleQuestionFormCardExpandedArea({
    super.key,
    required this.form,
    required this.reference,
  });
  final FirestoreForm form;
  final DocumentReference<FirestoreForm> reference;

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const hPadding = 8.0;
    const descriptionHPadding = 16;

    final currentUserVal = ref.watch(currentUserProvider);

    return currentUserVal.when(
      data: (currentUser) {
        final isAFormForUser =
            form.userIsInCorrectGroupForForm(currentUser.groupIds);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (form.description != null)
              Text(form.description!,
                      style: Theme.of(context).textTheme.bodyMedium)
                  .padding(horizontal: descriptionHPadding.toDouble()),
            if (form.isKoco)
              GestureDetector(
                onTap: () => context.pushNamed('My Allergies'),
                child: AllergyWarningCard(sidePadding: hPadding),
              ).padding(top: 16.0),
            Form(
              key: _formKey,
              child: Column(
                children: form.questions
                    .expand((q) => [
                          FormQuestion(
                            formQuestion: q,
                            form: form,
                            docRef: reference,
                            userCanEditForm: form.isOpen && isAFormForUser,
                            withoutBorder: true,
                            showAdditionalSaveButton: true,
                          ).padding(horizontal: hPadding),
                          const SizedBox(height: 2),
                        ])
                    .toList(),
              ),
            ),
            SingleQuestionFormCardDeleteButton(reference: reference),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
