import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_by_id_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_favorites_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/reservation_list_tile.dart';

class ShowTrainingPage extends ConsumerWidget {
  const ShowTrainingPage({super.key, required this.reservationDocumentId});
  final String reservationDocumentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteObjectsProvider);
    final reservationVal =
        ref.watch(reservationByIdProvider(reservationDocumentId));

    final currentUser = ref.watch(currentUserNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Afschrijving'),
      ),
      body: reservationVal.when(
        data: (data) {
          final reservation = data.data();

          return reservation == null
              ? const ErrorCardWidget(
                  errorMessage: "Geen afschrijving gevonden",
                )
              : ListView(
                  children: [
                    if (int.tryParse(reservation.creatorId) != null)
                      AlmanakUserTile(
                        firstName:
                            reservation.creatorName.split(' ')[0].toString(),
                        lastName: reservation.creatorName
                            .split(' ')
                            .sublist(1)
                            .join(' '),
                        lidnummer: reservation.creatorId
                      )
                      else 
                        DataTextListTile(
                          name: "Afschrijver",
                          value: reservation.creatorName,
                        ),
                    DataTextListTile(
                      name: "Object",
                      value: reservation.objectName,
                    ),
                    DataTextListTile(
                      name: "Datum",
                      value: DateFormat.yMMMMEEEEd('nl_NL')
                          .format(reservation.startTime),
                    ),
                    DataTextListTile(
                      name: "Starttijd",
                      value:
                          DateFormat.Hm('nl_NL').format(reservation.startTime),
                    ),
                    DataTextListTile(
                      name: "Eindtijd",
                      value: DateFormat.Hm('nl_NL').format(reservation.endTime),
                    ),
                  ],
                );
        },
        error: (err, stk) => ErrorCardWidget(
          errorMessage: err.toString(),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          reservationVal.when(
            data: (snapshot) =>
                // Only show delete button if the current user is the creator of the reservation.
                currentUser?.identifier.toString() == snapshot.data()?.creatorId
                    // ignore: arguments-ordering
                    ? FloatingActionButton(
                        tooltip: "Afschrijving verwijderen",
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                        heroTag: "deleteReservation",
                        onPressed: () =>
                            unawaited(showDeleteReservationDialogForTraining(
                          context,
                          reservationDocumentId,
                        )),
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      )
                    : const SizedBox.shrink(),
            error: (err, stk) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 5),
          reservationVal.when(
            data: (snapshot) {
              final objectName = snapshot.data()?.objectName;
              final isFavorite = favorites.contains(objectName);

              return (objectName != null)
                  ? FloatingActionButton.extended(
                      tooltip: "Object aan favorieten toevoegen",
                      onPressed: () => ref
                          .read(favoriteObjectsProvider.notifier)
                          .toggleObjectFavorite(objectName),
                      label: Row(
                        children: [
                          Text(isFavorite
                              ? "Verwijder object uit favorieten  "
                              : "Voeg object toe aan favorieten  "),
                          Icon(isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                        ],
                      ),
                    )
                  : const SizedBox.shrink();
            },
            error: (err, stk) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> showDeleteReservationDialogForTraining(
    BuildContext context,
    String reservationId,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Afschrijving verwijderen'),
          content: const Text(
            'Weet je zeker dat je jouw afschrijving wilt verwijderen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nee'),
            ),
            TextButton(
              // ignore: prefer-extracting-callbacks
              onPressed: () {
                deleteReservation(reservationId);
                context.goNamed('Planning Overview');
              },
              child: Text(
                'Verwijder mijn afschrijving',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
      useRootNavigator: false,
    );
  }
}
