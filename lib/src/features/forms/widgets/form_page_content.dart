import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_header.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class FormPageContent extends ConsumerWidget {
  const FormPageContent({
    required this.formKey,
    required this.session,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final FormSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = session.formDoc.data();
    if (form == null) {
      return const ErrorCardWidget(errorMessage: 'Formulier niet gevonden');
    }

    return ref.watch(currentUserProvider).when(
          data: (currentUser) {
            final isAFormForUser =
                form.userIsInCorrectGroupForForm(currentUser.groupIds);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pass session instead of answerSnapshot
                FormPageHeader(
                  form: form,
                  session: session,
                  isAFormForUser: isAFormForUser,
                ),
                FormPageForm(
                  formKey: formKey,
                  session: session,
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
