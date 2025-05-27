import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class FormsPage extends ConsumerWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allForms = ref.watch(allNonDraftFormsProvider);
    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final formsLocation = firestoreFormCollectionName[0].toUpperCase() +
        firestoreFormCollectionName.substring(1);

    return Scaffold(
      appBar: AppBar(title: Text(formsLocation)),
      body: currentUserVal.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s);
          return ErrorCardWidget(
              errorMessage: 'Fout bij het laden van gebruiker.');
        },
        data: (currentUser) => allForms.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, stack) =>
              ErrorCardWidget(errorMessage: error.toString()),
          data: (querySnapshot) {
            final forms = querySnapshot.docs;

            final openForms = (forms).where((form) {
              final formData = form.data();
              return formData.userCanEditForm &&
                  (formData.userIsInCorrectGroupForForm(currentUser.groupIds) ||
                      currentUser.isAdmin);
            }).toList();

            final closedForms = (forms).where((form) {
              final formData = form.data();
              return !formData.userCanEditForm &&
                  (formData.userIsInCorrectGroupForForm(currentUser.groupIds) ||
                      currentUser.isAdmin);
            }).toList();

            return ListView(
              padding: const EdgeInsets.all(8),
              children: [
                ...openForms.map((form) => FormCard(
                      formDoc: form,
                      currentUser: currentUser,
                    )),
                if (closedForms.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(),
                  ),
                  const Center(
                    child: Text(
                      'Gesloten Forms',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...closedForms.map((form) => FormCard(
                        formDoc: form,
                        currentUser: currentUser,
                      )),
                ]
              ],
            );
          },
        ),
      ),
      floatingActionButton: currentUserVal.when(
        data: (currentUser) => currentUser.canCreateForms
            ? FloatingActionButton.extended(
                tooltip: 'Beheer forms',
                foregroundColor: colorScheme.onTertiaryContainer,
                backgroundColor: colorScheme.tertiaryContainer,
                heroTag: "Manage Forms",
                onPressed: () => context.goNamed('Forms -> Manage Forms'),
                icon: const Icon(Icons.find_in_page),
                label: const Text('Beheer forms'),
              )
            : null,
        loading: () => const SizedBox.shrink(),
        error: (e, s) => const SizedBox.shrink(),
      ),
    );
  }
}
