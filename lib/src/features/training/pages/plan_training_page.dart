import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/api/reservations_for_object_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/model/reservations_query.dart';
import '../../shared/widgets/error_card_widget.dart';
import '../model/reservation.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PlanTrainingPage extends ConsumerStatefulWidget {
  PlanTrainingPage({
    super.key,
    required this.reservationObject,
    required this.startTime,
    required this.objectName,
  }) : date = DateTime(
          startTime.year,
          startTime.month,
          startTime.day,
        );

  final DocumentReference<ReservationObject> reservationObject;
  final DateTime startTime;
  final DateTime date;
  final String objectName;

  @override
  createState() => _PlanTrainingPageState();
}

class _PlanTrainingPageState extends ConsumerState<PlanTrainingPage> {
  DateTime _startTime = DateTime.now(); // Selected start time of the slider.
  DateTime _endTime = DateTime.now(); // Selected end time of the slider.

  bool inProgress = false;

  // Wordt op true gezet zodra er (bulk of enkel) succesvol geboekt is en de
  // pagina gaat sluiten. Voorkomt dat een binnenkomende Firestore-stream-update
  // een rebuild triggert die jouw zojuist aangemaakte reservering als conflict
  // toont vlak voordat de pagina wegnavigeert.
  bool _reservationCompleted = false;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.startTime.add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);

    final reservationsVal = ref.watch(reservationsProvider(
      ReservationsQuery(widget.date, widget.reservationObject),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Afschrijving'),
      ),
      body: inProgress
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : reservationsVal.when(
              data: (snapshot) => renderPage(snapshot, user),
              loading: () =>
                  const CircularProgressIndicator.adaptive().center(),
              error: (error, stk) =>
                  ErrorCardWidget(errorMessage: error.toString()),
            ),
    );
  }

  /// Pure controle: geeft de reservering terug die [desiredStartTime] overlapt,
  /// of null als het tijdstip vrij is. Gooit geen exceptions — bedoeld om veilig
  /// tijdens de build te draaien.
  Reservation? _conflictingReservation(
    QuerySnapshot<Reservation> snapshot,
    DateTime desiredStartTime,
  ) {
    for (final document in snapshot.docs) {
      final reservation = document.data();
      final sameStart =
          reservation.startTime.isAtSameMomentAs(desiredStartTime);

      if ((reservation.startTime.isBefore(desiredStartTime) || sameStart) &&
          reservation.endTime.isAfter(desiredStartTime)) {
        return reservation;
      }
    }
    return null;
  }

  /// Pure berekening: bepaalt het boekbare tijdvenster rond [desiredStartTime]
  /// op basis van bestaande reserveringen. Gooit geen exceptions meer; conflicten
  /// worden apart afgehandeld via [_conflictingReservation].
  DateTimeRange findAvailableTimerange(
    QuerySnapshot<Reservation> snapshot,
    DateTime desiredStartTime,
  ) {
    // People can reservate starting at 06:00 until 22:00.
    DateTime earliestPossibleTime = widget.date.add(const Duration(hours: 6));
    DateTime latestPossibleTime = widget.date.add(const Duration(hours: 22));

    for (final document in snapshot.docs) {
      final reservation = document.data();
      final sameStart =
          reservation.startTime.isAtSameMomentAs(desiredStartTime);

      if ((reservation.endTime.isBefore(desiredStartTime) ||
              reservation.endTime.isAtSameMomentAs(desiredStartTime)) &&
          reservation.endTime.isAfter(earliestPossibleTime)) {
        earliestPossibleTime = reservation.endTime;
      }

      if ((reservation.startTime.isAfter(desiredStartTime) || sameStart) &&
          reservation.startTime.isBefore(latestPossibleTime)) {
        latestPossibleTime = reservation.startTime;
      }
    }

    return DateTimeRange(start: earliestPossibleTime, end: latestPossibleTime);
  }

  // ignore: avoid-long-functions
  Widget renderPage(QuerySnapshot<Reservation> snapshot, User? currentUser) {
    if (currentUser == null) {
      return const ErrorCardWidget(
        errorMessage: "Er is iets misgegaan met het ophalen van je gegevens, "
            "probeer opnieuw in te loggen.",
      );
    }

    // De boeking is gelukt en de pagina sluit. Niet opnieuw valideren, anders
    // zien we onze eigen zojuist aangemaakte reservering als conflict.
    if (_reservationCompleted) {
      return const CircularProgressIndicator.adaptive().center();
    }

    // Conflict-controle gebeurt hier expliciet (geen throw meer in de build).
    final conflict = _conflictingReservation(snapshot, _startTime);
    if (conflict != null) {
      final isOwnReservation =
          conflict.creatorId == currentUser.identifier.toString();
      return ErrorCardWidget(
        errorMessage: isOwnReservation
            ? "Je hebt al een afschrijving op dit tijdstip, je kan niet twee "
                "keer achter elkaar afschrijven"
            : "Dit tijdstip is al bezet door ${conflict.creatorName}",
      );
    }

    const int timeRowItems = 3;

    final range = findAvailableTimerange(snapshot, _startTime);
    final (earliestPossibleTime, latestPossibleTime) = (range.start, range.end);

    if (_endTime.isAfter(latestPossibleTime)) {
      _endTime = latestPossibleTime;
    }

    const double fieldPadding = 16;
    const double timeSelectorDialogHandlerRadius = 8;

    final screenWidth = MediaQuery.of(context).size.width;
    const intervalOfSelector = Duration(minutes: 15);
    const minimumReservationDuration = Duration(minutes: 15);

    // Controleer of het geselecteerde object een ergometer is
    final isErgometer = widget.objectName.toLowerCase().contains('ergometer');

    return ListView(children: <Widget>[
      DataTextListTile(name: 'Boot', value: widget.objectName),
      DataTextListTile(
        name: "Datum",
        value: DateFormat.MMMMEEEEd('nl_NL').format(widget.date),
      ),
      Row(
        children: [
          SizedBox(
            width: screenWidth / timeRowItems,
            child: DataTextListTile(
              name: "Starttijd",
              value: DateFormat.Hm().format(_startTime),
            ),
          ),
          SizedBox(
            width: screenWidth / timeRowItems,
            child: DataTextListTile(
              name: "Eindtijd",
              value: DateFormat.Hm().format(_endTime),
            ),
          ),
          IconButton(
            onPressed: () => {
              showTimeRangePicker(
                context: context,
                start: TimeOfDay(
                  hour: _startTime.hour,
                  minute: _startTime.minute,
                ),
                end: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
                disabledTime: TimeRange(
                  startTime: TimeOfDay.fromDateTime(latestPossibleTime),
                  endTime: TimeOfDay.fromDateTime(earliestPossibleTime),
                ),
                disabledColor: Colors.grey,
                interval: intervalOfSelector,
                fromText: 'Starttijd',
                toText: 'Eindtijd',
                strokeColor: Colors.lightBlue,
                handlerRadius: timeSelectorDialogHandlerRadius,
                handlerColor: Colors.lightBlue,
                minDuration: minimumReservationDuration,
              ).then((value) {
                if (value == null || !mounted) return;

                final (startTimeOfDay, endTimeOfDay) =
                    (value.startTime as TimeOfDay, value.endTime as TimeOfDay);
                setState(() {
                  _endTime = DateTime(
                    widget.date.year,
                    widget.date.month,
                    widget.date.day,
                    endTimeOfDay.hour,
                    endTimeOfDay.minute,
                  );
                  _startTime = DateTime(
                    widget.date.year,
                    widget.date.month,
                    widget.date.day,
                    startTimeOfDay.hour,
                    startTimeOfDay.minute,
                  );
                });
              }),
            },
            icon: const Icon(Icons.tune, size: 40),
          ),
        ],
      ),
      ElevatedButton(
        onPressed: inProgress
            ? null
            : () => createReservation(
                  currentUser.identifier.toString(),
                  currentUser.fullName,
                  currentUser.isAdmin,
                ),
        child: <Widget>[
          Icon(inProgress ? LucideIcons.loader : LucideIcons.check)
              .padding(bottom: 1),
          Text(
            inProgress ? "Zwanen voeren..." : 'Afschrijven',
            style: const TextStyle(fontSize: 18),
          ).padding(vertical: fieldPadding),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      ).padding(all: fieldPadding),
      if (isErgometer)
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          icon: const Icon(Icons.playlist_add_check, size: 24),
          label: const Text(
            'Meerdere ergometers afschrijven...',
            style: TextStyle(fontSize: 18),
          ).padding(vertical: fieldPadding),
          onPressed: inProgress
              ? null
              : () => _openBulkErgometerSelection(
                    context,
                    currentUser.fullName,
                    currentUser.isAdmin,
                  ),
        ).padding(horizontal: fieldPadding, bottom: fieldPadding),
    ]);
  }

  void _openBulkErgometerSelection(
    BuildContext context,
    String creatorName,
    bool? creatorIsAdmin,
  ) async {
    setState(() {
      inProgress = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reservationObjects')
          .get();

      setState(() {
        inProgress = false;
      });

      final alleDocs = snapshot.docs.toList();
      final user = ref.read(currentUserNotifierProvider);

      final List<String> userPermissions = user?.firestorePermissions ?? [];

      // Genormaliseerd (lowercase + zonder spaties eromheen) zodat de
      // vergelijking hoofdletter-ongevoelig is.
      final Set<String> genormaliseerdePermissies =
          userPermissions.map((p) => p.toLowerCase().trim()).toSet();

      final alleErgs = alleDocs.where((doc) {
        final data = doc.data();
        final name = (data['name'] ?? doc.id).toString().toLowerCase();
        final docId = doc.id.toLowerCase();

        final isErg = name.contains('ergometer') ||
            name.contains('ergo') ||
            docId.contains('ergometer') ||
            docId.contains('ergo');
        if (!isErg) return false;

        if (creatorIsAdmin == true) return true;

        // Welke bevoegdheid vereist dit object? Het veld 'permissions' kan één
        // string zijn (bijv. 'wedstrijd ergometers') of een lijst daarvan.
        final dynamic permissieVeld = data['permissions'];
        final List<String> benodigdePermissies = permissieVeld == null
            ? <String>[]
            : permissieVeld is Iterable
                ? permissieVeld.map((p) => p.toString()).toList()
                : <String>[permissieVeld.toString()];

        // Geen vereiste ingesteld -> iedereen mag deze ergometer zien.
        if (benodigdePermissies.isEmpty) return true;

        // Alleen tonen als de gebruiker minstens één vereiste bevoegdheid heeft.
        // Hoofdletter-ongevoelig, zodat 'Wedstrijd Ergometers' en
        // 'wedstrijd ergometers' als gelijk gelden.
        return benodigdePermissies.any(
          (p) => genormaliseerdePermissies.contains(p.toLowerCase().trim()),
        );
      }).toList();

      if (alleErgs.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Geen ergometers beschikbaar voor jouw permissieniveau.')),
          );
        }
        return;
      }

      List<DocumentReference> geselecteerdeErgs = [widget.reservationObject];

      if (!context.mounted) return;

      // De dialog geeft alleen de selectie terug (of null bij annuleren).
      // Het daadwerkelijke boeken gebeurt HIERNA, met de context van de pagina,
      // zodat de context niet al unmounted is door het sluiten van de dialog.
      final geselecteerd = await showDialog<List<DocumentReference>>(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (builderContext, setDialogState) {
              return AlertDialog(
                title: const Text('Selecteer Ergometers'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: alleErgs.length,
                    itemBuilder: (itemContext, index) {
                      final doc = alleErgs[index];
                      final name = doc.data()['name'] ?? doc.id;
                      final ref = doc.reference;

                      // Check of dit de ergometer is waarmee de pagina geopend is
                      final isHuidigeErgometer =
                          ref.path == widget.reservationObject.path;
                      final isSelected = geselecteerdeErgs.contains(ref);

                      return CheckboxListTile(
                        title: Text(name),
                        // Als dit de huidige ergometer is, staat hij op true
                        value: isHuidigeErgometer ? true : isSelected,
                        activeColor: Colors.blue,
                        onChanged: isHuidigeErgometer
                            ? null // Maak hem 'disabled' voor wijzigingen zodat de gebruiker hem niet per ongeluk kan uitvinken
                            : (bool? checked) {
                                setDialogState(() {
                                  if (checked == true) {
                                    geselecteerdeErgs.add(ref);
                                  } else {
                                    geselecteerdeErgs.remove(ref);
                                  }
                                });
                              },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Annuleren'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext, geselecteerdeErgs),
                    child: Text('Boek ${geselecteerdeErgs.length} ergometers'),
                  ),
                ],
              );
            },
          );
        },
      );

      // Geannuleerd of niets gekozen: stoppen.
      if (geselecteerd == null || geselecteerd.isEmpty) return;
      if (!mounted) return;

      setState(() {
        inProgress = true;
      });

      int succesvolleBoekingen = 0;
      final List<String> fouten = [];

      for (final ergRef in geselecteerd) {
        final ergDoc =
            alleErgs.firstWhere((d) => d.reference.path == ergRef.path);
        final ergName = ergDoc.data()['name'] ?? ergDoc.id;

        try {
          await FirebaseFunctions.instanceFor(region: 'europe-west1')
              .httpsCallable('createReservation')
              .call({
            'startTime': _startTime.toUtc().toIso8601String(),
            'endTime': _endTime.toUtc().toIso8601String(),
            'object': ergRef.path,
            'objectName': ergName,
            'creatorName': creatorName,
            'creatorIsAdmin': creatorIsAdmin,
          });
          succesvolleBoekingen++;
        } catch (e) {
          fouten.add('$ergName: $e');
        }
      }

      if (!mounted) return;

      // Markeer voltooid VOORDAT de pagina rebuild/sluit, zodat de stream-update
      // je eigen nieuwe reservering niet als conflict toont.
      setState(() {
        _reservationCompleted = true;
        inProgress = false;
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        fouten.isEmpty
            ? SnackBar(
                content: Text(
                    '$succesvolleBoekingen ergometers succesvol afgeschreven!'),
                backgroundColor: Colors.green,
              )
            : SnackBar(
                content: Text(
                    '$succesvolleBoekingen gelukt. Overige ergometers gaven een tijdconflict of permissiefout.'),
                backgroundColor: Colors.orange,
              ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        inProgress = false;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Fout bij ophalen ergometers: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  void createReservation(
    String uid,
    String creatorName,
    bool? creatorIsAdmin,
  ) async {
    setState(() {
      inProgress = true;
    });

    final res = await createReservationCloud(Reservation(
      startTimestamp: Timestamp.fromDate(_startTime),
      endTimestamp: Timestamp.fromDate(_endTime),
      reservationObject: widget.reservationObject,
      creatorId: uid,
      objectName: widget.objectName,
      creatorName: creatorName,
      creatorIsAdmin: creatorIsAdmin,
    ));

    if (!mounted) return;

    if (res['success'] == true) {
      FirebaseAnalytics.instance.logEvent(
        name: 'reservation_created',
        parameters: <String, dynamic>{
          'reservation_object_name': widget.objectName,
        },
      );
      // Markeer voltooid voor de pop zodat de stream-update niet je eigen
      // nieuwe reservering als conflict toont.
      setState(() {
        _reservationCompleted = true;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Afschrijving gelukt!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (context.mounted) {
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Afschrijving mislukt! ${res['error']}",
            ).textColor(colorScheme.onErrorContainer),
            backgroundColor: colorScheme.errorContainer,
          ),
        );
      }
    }

    if (context.mounted) {
      context.pop();
    }
  }

  Future<Map<String, dynamic>> createReservationCloud(Reservation r) async {
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('createReservation')
          .call({
        'startTime': r.startTime.toUtc().toIso8601String(),
        'endTime': r.endTime.toUtc().toIso8601String(),
        'object': r.reservationObject.path,
        'objectName': r.objectName,
        'creatorName': r.creatorName,
        'creatorIsAdmin': r.creatorIsAdmin,
      });

      return result.data;
    } on FirebaseFunctionsException catch (error) {
      return {'success': false, 'error': error.message};
    }
  }
}
