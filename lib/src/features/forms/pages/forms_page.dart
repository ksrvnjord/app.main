import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsPage extends ConsumerWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allForms = ref.watch(allNonDraftFormsProvider);
    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('forms')),
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
                    return FormCard(formDoc: item);
                  })
                  .toList()
                  .toColumn(separator: const SizedBox(height: 4));
            },
            error: (error, stack) {
              return ErrorCardWidget(errorMessage: error.toString());
            },
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ],
      ),
      floatingActionButton: currentUserVal.when(
        // ignore: prefer-extracting-function-callbacks
        data: (currentUser) {
          final canAccesAdminPanel = currentUser.canCreateForms;

          return canAccesAdminPanel
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      tooltip: 'Maak een nieuwe form aan',
                      foregroundColor: colorScheme.onTertiaryContainer,
                      backgroundColor: colorScheme.tertiaryContainer,
                      heroTag: "Create Form",
                      onPressed: () => context.goNamed('Forms -> Create Form'),
                      icon: const Icon(Icons.add),
                      label: const Text('Maak een nieuwe form'),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.extended(
                      tooltip: 'Beheer forms',
                      foregroundColor: colorScheme.onTertiaryContainer,
                      backgroundColor: colorScheme.tertiaryContainer,
                      heroTag: "Manage Forms",
                      onPressed: () => context.goNamed('Forms -> Manage Forms'),
                      icon: const Icon(Icons.find_in_page),
                      label: const Text('Beheer forms'),
                    ),
                  ],
                )
              : null;
        },
        // ignore: prefer-extracting-function-callbacks
        error: (e, s) {
          // ignore: avoid-async-call-in-sync-function
          FirebaseCrashlytics.instance.recordError(e, s);

          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
