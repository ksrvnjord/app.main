// ignore_for_file: prefer-extracting-function-callbacks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({super.key});

  Widget _buildOpenFormsList(
    BuildContext context,
    List<QueryDocumentSnapshot<FirestoreForm>> formReferences,
    User currentUser,
  ) {
    const hPadding = 8.0;

    final openFormsList = [
      ...formReferences.where((formReference) {
        final form = formReference.data();
        return form.userIsInCorrectGroupForForm(currentUser.groupIds) ||
            currentUser.isAdmin;
      }).map((formSnapshot) {
        final formData = formSnapshot.data();
        return (formData.questions.length == 1 ||
                formData.formContentObjectIds.length == 1)
            ? SingleQuestionFormCard(formSnapshot: formSnapshot)
            : FormCard(
                formDoc: formSnapshot,
                currentUser: currentUser,
                pushContext: true,
              );
      }),
    ];

    return [
      ...openFormsList.take(3),
      if (openFormsList.length > 3)
        GestureDetector(
          onTap: () => context.goNamed(RouteName.forms),
          child: Icon(Icons.more_horiz, size: 32),
        ),
    ].toColumn().padding(horizontal: hPadding);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openForms = ref.watch(openFormsProvider);
    final currentUserVal = ref.watch(currentUserProvider);

    return [
      WidgetHeader(
        title: "Forms",
        titleIcon: Icons.edit_document,
        onTapName: "Alle forms",
        onTap: () => context.goNamed(RouteName.forms),
      ),
      openForms.when(
        // ignore: prefer-extracting-function-callbacks
        data: (querySnapshot) {
          final formsDocuments = querySnapshot.docs;
          return currentUserVal.when(
            data: (currentUser) =>
                _buildOpenFormsList(context, formsDocuments, currentUser),
            error: (error, stack) =>
                ErrorTextWidget(errorMessage: error.toString()),
            loading: () => const CircularProgressIndicator.adaptive(),
          );
        },
        error: (error, stack) =>
            ErrorTextWidget(errorMessage: error.toString()),
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    ].toColumn();
  }
}
