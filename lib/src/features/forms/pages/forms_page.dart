import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsPage extends ConsumerWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allForms = ref.watch(allFormsProvider);
    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final formsLocation = firestoreFormCollectionName[0].toUpperCase() +
        firestoreFormCollectionName.substring(1);

    return Scaffold(
      appBar: AppBar(title: Text(formsLocation)),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          allForms.when(
            // ignore: prefer-extracting-function-callbacks
            data: (querySnapshot) {
              final forms = querySnapshot.docs;

              return forms
                  // ignore: prefer-extracting-function-callbacks
                  .map((item) {
                    return FormCard(
                      formDoc: item,
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
                    );
                  })
                  .toList()
                  .toColumn(separator: const SizedBox(height: 4));
            },
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ],
      ),
      floatingActionButton: currentUserVal.when(
        // ignore: prefer-extracting-function-callbacks
        data: (currentUser) {
          final canAccesAdminPanel = currentUser.isAdmin;

          return canAccesAdminPanel
              ? FloatingActionButton.extended(
                  tooltip: 'Maak een nieuwe form aan',
                  foregroundColor: colorScheme.onTertiaryContainer,
                  backgroundColor: colorScheme.tertiaryContainer,
                  heroTag: "Create Form",
                  onPressed: () => context.goNamed('Forms -> Create Form'),
                  icon: const Icon(Icons.add),
                  label: const Text('Maak een nieuwe form'),
                )
              : null;
        },
        // ignore: prefer-extracting-function-callbacks
        error: (e, s) {
          // ignore: avoid-async-call-in-sync-function
          FirebaseCrashlytics.instance.recordError(e, s);

          return const SizedBox.shrink();
        },
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
