import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_header.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class FormPageContent extends ConsumerWidget {
  const FormPageContent(
      {required this.formDoc, required this.formKey, super.key});
  final DocumentSnapshot<FirestoreForm> formDoc;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = formDoc.data()!;
    final answerVal = ref.watch(formAnswerProvider(formDoc.reference));
    final currentUserVal = ref.watch(currentUserProvider);

    return answerVal.when(
      data: (answer) => currentUserVal.when(
        data: (currentUser) {
          final isAFormForUser =
              form.userIsInCorrectGroupForForm(currentUser.groupIds);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormPageHeader(
                form: form,
                answer: answer,
                isAFormForUser: isAFormForUser,
              ),
              FormPageForm(
                formDoc: formDoc,
                formKey: formKey,
                isAFormForUser: isAFormForUser,
              ),
            ],
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (err, _) => ErrorCardWidget(errorMessage: err.toString()),
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, _) => ErrorCardWidget(errorMessage: err.toString()),
    );
  }
}
