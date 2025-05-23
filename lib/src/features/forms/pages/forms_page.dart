import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
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
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          allForms.when(
            data: (querySnapshot) {
              final forms = querySnapshot.docs;

              final openForms = forms.where((form) {
                final formData = form.data();
                final openUntil = formData.openUntil;
                final formIsOpen = DateTime.now().isBefore(openUntil);
                return formIsOpen;
              }).toList();

              final closedForms = forms.where((form) {
                final formData = form.data();
                final openUntil = formData.openUntil;
                final formIsOpen = DateTime.now().isBefore(openUntil);
                return !formIsOpen;
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...openForms
                      .map((item) => _buildFormCard(item, currentUserVal)),
                  if (closedForms.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(),
                    ),
                    const Center(
                      child: Text(
                        'Gesloten Forms',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...closedForms
                        .map((item) => _buildFormCard(item, currentUserVal)),
                  ],
                ],
              );
            },
            error: (error, stack) {
              return ErrorCardWidget(errorMessage: error.toString());
            },
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ],
      ),
      floatingActionButton: currentUserVal.when(
        data: (currentUser) {
          final canCreateForms = currentUser.canCreateForms;

          return canCreateForms
              ? FloatingActionButton.extended(
                  tooltip: 'Beheer forms',
                  foregroundColor: colorScheme.onTertiaryContainer,
                  backgroundColor: colorScheme.tertiaryContainer,
                  heroTag: "Manage Forms",
                  onPressed: () => context.goNamed('Forms -> Manage Forms'),
                  icon: const Icon(Icons.find_in_page),
                  label: const Text('Beheer forms'),
                )
              : null;
        },
        error: (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s);
          return const SizedBox.shrink();
        },
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _buildFormCard(
    QueryDocumentSnapshot<FirestoreForm> item,
    AsyncValue<User> currentUserVal,
  ) {
    return FormCard(
      formDoc: item,
      userGroups: currentUserVal.when(
        data: (currentUser) {
          final userGroups = currentUser.groups
              .where((group) => group.group.id != null)
              .map((group) => group.group.id!);

          return userGroups;
        },
        error: (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s);
          return const [];
        },
        loading: () => const [],
      ),
      userIsAdmin: currentUserVal.when(
        data: (currentUser) => currentUser.isAdmin,
        error: (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s);
          return false;
        },
        loading: () => false,
      ),
    );
  }
}
