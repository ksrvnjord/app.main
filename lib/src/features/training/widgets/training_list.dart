import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/my_reservations_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/reservation_list_tile.dart';

class TrainingList extends ConsumerWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(firebaseAuthUserProvider) == null) {
      // This should show to the user that there are no reservations.
      return const Center(
        child: Text('Je hebt geen afschrijvingen'),
      );
    }

    return ref.watch(myReservationsProvider).when(
          error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) => data.docs.isEmpty
              ? const Center(
                  // ignore: avoid-non-ascii-symbols
                  child: Text('Je hebt geen afschrijvingen op dit moment'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) =>
                      ReservationListTile(snapshot: data.docs[index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 4),
                  itemCount: data.docs.length,
                ),
        );
  }
}
