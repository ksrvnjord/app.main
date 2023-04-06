import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';

final CollectionReference<Poll> pollsCollection =
    FirebaseFirestore.instance.collection('polls').withConverter<Poll>(
          fromFirestore: (snapshot, _) => Poll.fromJson(snapshot.data()!),
          toFirestore: (poll, _) => poll.toJson(),
        );

// retrieves all the polls
final pollsProvider = FutureProvider<QuerySnapshot<Poll>>((ref) {
  return pollsCollection.orderBy('openUntil', descending: true).get();
});

final openPollsProvider =
    FutureProvider<QuerySnapshot<Poll>>((ref) => pollsCollection
        .where('openUntil', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy(
          'openUntil',
          descending: false,
        ) // show the poll with closest deadline first
        .limit(3)
        .get());
