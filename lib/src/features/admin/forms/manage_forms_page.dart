import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/admin/forms/form_reaction_count_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class ManageFormsPage extends ConsumerWidget {
  const ManageFormsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Beheer Forms')),
      body: currentUserVal.when(
        data: (user) {
          final formsVal = ref.watch(
            user.isAdmin
                ? allFormsOnCreationProvider
                : creatorNamesFormsOnCreationProvider,
          );
          return formsVal.when(
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
                          if (form.isDraft ?? false)
                            user.isAdmin
                                ? ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Draftstatus opheffen'),
                                            content: const Text(
                                                'Weet je zeker dat je de draftstatus wilt opheffen? Dit maakt de form zichtbaar voor iedereen.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Annuleren'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Bevestigen'),
                                                onPressed: () {
                                                  FormRepository
                                                      .removeDraftStatus(
                                                          doc.reference);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Hef draftstatus op',
                                    ),
                                  )
                                : const Text(
                                    'Draft',
                                    style: TextStyle(color: Colors.red),
                                  )
                          else
                            Text(partialReactionVal.maybeWhen(
                              data: (count) =>
                                  "Volledig + onvolledig ingevulde reacties: $count",
                              orElse: () => "",
                            )),
                        ].toColumn(
                            crossAxisAlignment: CrossAxisAlignment.start),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => innerContext.go(
                            '${GoRouterState.of(innerContext).uri}/${doc.id}'),
                      );
                    },
                    itemCount: snapshot.size,
                  ),
            error: (error, stack) => Center(
              child: ErrorTextWidget(
                errorMessage: error.toString(),
              ),
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          );
        },
        error: (error, stack) => ErrorTextWidget(
          errorMessage: error.toString(),
        ),
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
