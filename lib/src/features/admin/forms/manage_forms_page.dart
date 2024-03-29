import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/admin/forms/form_reaction_count_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:styled_widget/styled_widget.dart';

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
                padding: const EdgeInsets.only(bottom: 80),
                itemBuilder: (innerContext, index) {
                  // ignore: avoid-unsafe-collection-methods
                  final doc = snapshot.docs[index];
                  final form = doc.data();

                  final formIsOpen =
                      form.openUntil.toDate().isAfter(DateTime.now());

                  final partialReactionVal = ref.watch(
                    formPartialReactionCountProvider(doc.id),
                  );

                  return ListTile(
                    title: Text(form.title),
                    subtitle: [
                      Text(
                        "${formIsOpen ? "Open tot" : "Gesloten op"} ${DateFormat('dd-MM-yyyy HH:mm').format(form.openUntil.toDate())}",
                      ),
                      Text(partialReactionVal.maybeWhen(
                        data: (count) =>
                            "Volledig + onvolledig ingevulde reacties: $count",
                        orElse: () => "",
                      )),
                    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => innerContext.goNamed(
                      'View Form',
                      pathParameters: {'formId': doc.id},
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
