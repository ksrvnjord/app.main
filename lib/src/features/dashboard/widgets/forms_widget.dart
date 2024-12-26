// ignore_for_file: prefer-extracting-function-callbacks

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openForms = ref.watch(openFormsProvider);
    final currentUserVal = ref.watch(currentUserProvider);

    const hPadding = 8.0;

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

          return [
            ...forms.map((item) {
              final form = item.data();

              return form.questions.length == 1
                  ? SingleQuestionFormCard(
                      userGroups: currentUserVal.when(
                        data: (currentUser) {
                          return currentUser.groups.map((group) => group.id);
                        },
                        error: (e, s) {
                          // ignore: avoid-async-call-in-sync-function
                          FirebaseCrashlytics.instance.recordError(e, s);

                          return const [];
                        },
                        loading: () => const [],
                      ),
                      userIsAdmin: currentUserVal.when(
                        data: (currentUser) => currentUser.isAdmin,
                        error: (e, s) {
                          // ignore: avoid-async-call-in-sync-function
                          FirebaseCrashlytics.instance.recordError(e, s);

                          return false;
                        },
                        loading: () => false,
                      ),
                      userGroupsString: currentUserVal.when(
                        data: (currentUser) {
                          return currentUser.groups
                              .map((group) => group.group.name);
                        },
                        error: (e, s) {
                          // ignore: avoid-async-call-in-sync-function
                          FirebaseCrashlytics.instance.recordError(e, s);

                          return const [];
                        },
                        loading: () => const [],
                      ),
                      formDoc: item)
                  : FormCard(
                      userGroups: currentUserVal.when(
                        data: (currentUser) {
                          return currentUser.groups.map((group) => group.id);
                        },
                        error: (e, s) {
                          // ignore: avoid-async-call-in-sync-function
                          FirebaseCrashlytics.instance.recordError(e, s);

                          return const [];
                        },
                        loading: () => const [],
                      ),
                      userIsAdmin: currentUserVal.when(
                        data: (currentUser) => currentUser.isAdmin,
                        error: (e, s) {
                          // ignore: avoid-async-call-in-sync-function
                          FirebaseCrashlytics.instance.recordError(e, s);

                          return false;
                        },
                        loading: () => false,
                      ),
                      userGroupsString: currentUserVal.when(
                        data: (currentUser) {
                          return currentUser.groups
                              .map((group) => group.group.name);
                        },
                        error: (e, s) {
                          // ignore: avoid-async-call-in-sync-function
                          FirebaseCrashlytics.instance.recordError(e, s);

                          return const [];
                        },
                        loading: () => const [],
                      ),
                      formDoc: item);
            }),
          ].toColumn().padding(horizontal: hPadding);
        },
        error: (error, stack) => Text(error.toString()),
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    ].toColumn();
  }
}
