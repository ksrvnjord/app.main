import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class ManageFormsPage extends ConsumerWidget {
  const ManageFormsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formsVal = ref.watch(allFormsOnCreationProvider);
    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Beheer Forms')),
      body: formsVal.when(
        data: (snapshot) => snapshot.docs.isEmpty
            ? const Center(child: Text('Geen forms gevonden'))
            : ListView.builder(
                itemBuilder: (innerContext, index) {
                  // ignore: avoid-unsafe-collection-methods
                  final form = snapshot.docs[index];

                  return ListTile(
                    title: Text(form['formName']),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => innerContext.goNamed(
                      'View Form',
                      pathParameters: {'formId': form.id},
                    ),
                  );
                },
                itemCount: snapshot.size,
              ),
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
      floatingActionButton: currentUserVal.when(
        data: (currentUser) {
          final canAccesAdminPanel = currentUser.isAdmin;

          return canAccesAdminPanel
              ? FloatingActionButton.extended(
                  tooltip: 'Maak een nieuwe form aan',
                  foregroundColor: colorScheme.onTertiaryContainer,
                  backgroundColor: colorScheme.tertiaryContainer,
                  heroTag: "Create Form",
                  onPressed: () => context.goNamed('Admin -> Create Form'),
                  icon: const Icon(Icons.add),
                  label: const Text('Maak een nieuwe form'),
                )
              : null;
        },
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
