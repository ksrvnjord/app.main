import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

final pollAnswerProvider =
    StreamProvider.family<QuerySnapshot<PollAnswer>, DocumentReference>(
  (ref, docRef) {
    final user = ref.watch(currentFirebaseUserProvider);
    final CollectionReference<PollAnswer> pollsCollection = FirebaseFirestore
        .instance
        .collection('${docRef.path}/answers')
        .withConverter<PollAnswer>(
          fromFirestore: (snapshot, _) => PollAnswer.fromJson(snapshot.data()!),
          toFirestore: (answer, _) => answer.toJson(),
        );

    return pollsCollection.where('userId', isEqualTo: user?.uid).snapshots();
  },
);
