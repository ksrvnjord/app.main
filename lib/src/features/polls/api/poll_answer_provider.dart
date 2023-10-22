import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll_answer.dart';

// ignore: prefer-static-class
final pollAnswerProvider =
    StreamProvider.family<QuerySnapshot<PollAnswer>, DocumentReference>(
  (ref, docRef) {
    final user = ref.watch(firebaseAuthUserProvider).value;
    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('${docRef.path}/answers')
        .withConverter<PollAnswer>(
          fromFirestore: (snapshot, _) =>
              PollAnswer.fromJson(snapshot.data() ?? {}),
          toFirestore: (answer, _) => answer.toJson(),
        )
        .where('userId', isEqualTo: user.uid)
        .snapshots();
  },
);
