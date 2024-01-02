import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';

/// Providers used for the migration from the old d polls to the new forms.

// ignore: prefer-static-class
final formsPollsCombinationProvider =
    FutureProvider.autoDispose<List<Object>>((ref) async {
  final forms = ref.watch(allFormsProvider.future);

  final polls = ref.watch(allPollsProvider.future);

  final querySnapshots = await Future.wait([forms, polls]);

  final alldocs = querySnapshots.expand((element) => element.docs).toList();
  alldocs.sort(PollsMigration.comparePollsFormsCombination);

  return alldocs;
});

// ignore: prefer-static-class
final openFormsPollsCombinationProvider =
    FutureProvider.autoDispose<List<Object>>((ref) async {
  final forms = ref.watch(openFormsProvider.future);

  final polls = ref.watch(openPollsProvider.future);

  final querySnapshots = await Future.wait([forms, polls]);

  final alldocs = querySnapshots.expand((element) => element.docs).toList();
  alldocs.sort(PollsMigration.comparePollsFormsCombination);

  return alldocs;
});

// ignore: prefer-match-file-name
class PollsMigration {
  static int comparePollsFormsCombination(
    QueryDocumentSnapshot<Object> a,
    QueryDocumentSnapshot<Object> b,
  ) {
    DateTime aOpenUntil = DateTime.now();
    // ignore: avoid-similar-names
    DateTime bOpenUntil = DateTime.now();

    switch (a.runtimeType.toString()) {
      case "_WithConverterQueryDocumentSnapshot<FirestoreForm>":
        // ignore: avoid-mutating-parameters
        a = a as QueryDocumentSnapshot<FirestoreForm>;
        aOpenUntil = a.data().openUntil;
        break;

      case "_WithConverterQueryDocumentSnapshot<Poll>":
        // ignore: avoid-mutating-parameters
        a = a as QueryDocumentSnapshot<Poll>;
        aOpenUntil = a.data().openUntil;
        break;

      default:
        throw Exception('Unknown type ${a.runtimeType}');
    }

    switch (b.runtimeType.toString()) {
      case "_WithConverterQueryDocumentSnapshot<FirestoreForm>":
        // ignore: avoid-mutating-parameters
        b = b as QueryDocumentSnapshot<FirestoreForm>;
        bOpenUntil = b.data().openUntil;
        break;

      case "_WithConverterQueryDocumentSnapshot<Poll>":
        // ignore: avoid-mutating-parameters
        b = b as QueryDocumentSnapshot<Poll>;
        bOpenUntil = b.data().openUntil;
        break;

      default:
        throw Exception('Unknown type ${b.runtimeType}');
    }

    return aOpenUntil.compareTo(bOpenUntil) * -1;
  }
}
