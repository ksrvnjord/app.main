import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_polls_combination_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/widgets/poll_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsPage extends ConsumerWidget {
  const FormsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formsAndPolls = ref.watch(formsPollsCombinationProvider);
    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Forms')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          formsAndPolls.when(
            data: (data) {
              return data
                  .map((item) {
                    final snapshot = item as QueryDocumentSnapshot;
                    final parentCollectionId = snapshot.reference.parent.id;
                    switch (parentCollectionId) {
                      // Unfortunate workaround for the fact that the type of the item is not a known type.
                      case "forms":
                        return FormCard(
                          formDoc: item as QueryDocumentSnapshot<FirestoreForm>,
                        );

                      case "polls":
                        return PollCard(
                          pollDoc: item as QueryDocumentSnapshot<Poll>,
                        );

                      default:
                        return const ErrorCardWidget(
                          errorMessage: "Onbekend formtype",
                        );
                    }
                  })
                  .toList()
                  .toColumn(separator: const SizedBox(height: 4));
            },
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
              stackTrace: stack,
            ),
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ],
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
                  onPressed: () => context.goNamed('Forms -> Create Form'),
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
