import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_by_id_provider.dart';

class ShowTrainingPage extends ConsumerWidget {
  final String reservationDocumentId;
  const ShowTrainingPage({Key? key, required this.reservationDocumentId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationVal =
        ref.watch(reservationByIdProvider(reservationDocumentId));

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
    );
  }
}
