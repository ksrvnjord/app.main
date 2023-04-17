import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/my_reservations_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list_item.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingList extends ConsumerWidget {
  const TrainingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(firebaseAuthUserProvider) == null) {
      // this should show to the user that there are no reservations
      return const Center(
        child: Text('Je hebt geen afschrijvingen'),
      );
    }

    return ref.watch(myReservationsProvider).when(
          data: (snapshot) => snapshot.size == 0
              ? Center(
                  // ignore: avoid-non-ascii-symbols
                  child: const Text('Het is wel leeg hier...')
                      .textColor(Colors.blueGrey),
                )
              : ListView.separated(
                  itemCount: snapshot.docs.length,
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (BuildContext context, int index) => Center(
                    child: TrainingListItem(reservation: snapshot.docs[index]),
                  ),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => Center(
            child: ErrorCardWidget(errorMessage: error.toString()),
          ),
        );
  }
}
