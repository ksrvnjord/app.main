import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/my_reservations_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/reservation_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingList extends ConsumerWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(firebaseAuthUserProvider) == null) {
      // this should show to the user that there are no reservations
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
              ? Center(
                  // ignore: avoid-non-ascii-symbols
                  child: const Text('Je hebt geen afschrijvingen op dit moment')
                      .textColor(Colors.blueGrey),
                )
              : ListView.separated(
                  itemCount: data.docs.length,
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (BuildContext context, int index) => Center(
                    child: ReservationListTile(snapshot: data.docs[index]),
                  ),
                ),
        );
  }
}
