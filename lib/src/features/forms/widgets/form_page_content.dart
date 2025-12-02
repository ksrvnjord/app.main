import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_header.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class FormPageContent extends ConsumerWidget {
  const FormPageContent(
      {required this.formDoc,
      required this.formKey,
      required this.answerSnapshot,
      super.key});
  final DocumentSnapshot<FirestoreForm> formDoc;
  final GlobalKey<FormState> formKey;
  final QuerySnapshot<FormAnswer> answerSnapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = formDoc.data()!;
    final currentUserVal = ref.watch(currentUserProvider);

    return currentUserVal.when(
      data: (currentUser) {
        final isAFormForUser =
            form.userIsInCorrectGroupForForm(currentUser.groupIds);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Now you have answer, so you can pass it here
            FormPageHeader(
                form: form,
                answerSnapshot: answerSnapshot,
                isAFormForUser: isAFormForUser),
            FormPageForm(
              formDoc: formDoc,
              formKey: formKey,
              answerSnapshot: answerSnapshot,
              isAFormForUser: isAFormForUser,
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, _) => ErrorCardWidget(errorMessage: err.toString()),
    );
  }
}
