import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';

// ignore: prefer-static-class
final CollectionReference<Poll> pollsCollection =
    FirebaseFirestore.instance.collection('polls').withConverter<Poll>(
          fromFirestore: (snapshot, _) => Poll.fromJson(snapshot.data() ?? {}),
          toFirestore: (poll, _) => poll.toJson(),
        );

// Retrieves all the polls.
// ignore: prefer-static-class
final pollsProvider = FutureProvider<QuerySnapshot<Poll>>((ref) {
  return pollsCollection.orderBy('openUntil', descending: true).get();
});

// ignore: prefer-static-class
final openPollsProvider =
    FutureProvider<QuerySnapshot<Poll>>((ref) => pollsCollection
        .where('openUntil', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy(
          'openUntil',
          descending: false,
        ) // Show the poll with closest deadline first.
        .limit(3)
        .get());
