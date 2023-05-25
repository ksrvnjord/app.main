import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

// ignore: prefer-static-class
final pollAnswerProvider =
    StreamProvider.family<QuerySnapshot<PollAnswer>, DocumentReference>(
  (ref, docRef) {
    final user = ref.watch(firebaseAuthUserProvider);
    final CollectionReference<PollAnswer> pollsCollection = FirebaseFirestore
        .instance
        .collection('${docRef.path}/answers')
        .withConverter<PollAnswer>(
          fromFirestore: (snapshot, _) =>
              PollAnswer.fromJson(snapshot.data() ?? {}),
          toFirestore: (answer, _) => answer.toJson(),
        );

    return pollsCollection.where('userId', isEqualTo: user?.uid).snapshots();
  },
);
