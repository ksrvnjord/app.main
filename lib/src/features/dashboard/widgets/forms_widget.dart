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
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({super.key});

  Widget _buildOpenFormsList(
    List<QueryDocumentSnapshot<FirestoreForm>> data,
  ) {
    const hPadding = 8.0;

    return [
      ...data.map((item) {
        final form = item.data();
        final userCanAddPhoto = form.userCanAddPhoto ?? false;

        return form.questions.length == 1 && userCanAddPhoto == false
            ? SingleQuestionFormCard(formDoc: item)
            : FormCard(formDoc: item);
      }),
    ].toColumn().padding(horizontal: hPadding);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openForms = ref.watch(openFormsProvider);

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
          final forms = querySnapshot.docs;

          return _buildOpenFormsList(forms);
        },
        error: (error, stack) => Text(
          error.toString(),
        ),
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    ].toColumn();
  }
}
