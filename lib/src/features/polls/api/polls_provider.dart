import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';

// ignore: prefer-static-class
final CollectionReference<Poll> pollsCollection =
    FirebaseFirestore.instance.collection('polls').withConverter<Poll>(
          fromFirestore: (snapshot, _) => Poll.fromJson(snapshot.data() ?? {}),
          toFirestore: (poll, _) => poll.toJson(),
        );

// ignore: prefer-static-class
final openPollsProvider =
    StreamProvider.autoDispose<QuerySnapshot<Poll>>((ref) {
  return ref.watch(firebaseAuthUserProvider).value != null
      ? pollsCollection
          .where('openUntil', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy(
            'openUntil',
            descending: false,
          ) // Show the poll with closest deadline first.
          .limit(3)
          .snapshots()
      : const Stream.empty();
});

// ignore: prefer-static-class
final allPollsProvider = StreamProvider.autoDispose<QuerySnapshot<Poll>>((ref) {
  return ref.watch(firebaseAuthUserProvider).value != null
      ? pollsCollection
          .orderBy(
            'openUntil',
            descending: true,
          ) // Show the poll with closest deadline first.
          .snapshots()
      : const Stream.empty();
});

// ignore: prefer-static-class
final pollProvider = StreamProvider.autoDispose
    .family<DocumentSnapshot<Poll>, String>((ref, pollId) {
  return ref.watch(firebaseAuthUserProvider).value != null
      ? pollsCollection.doc(pollId).snapshots()
      : const Stream.empty();
});
