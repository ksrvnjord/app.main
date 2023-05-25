import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';

// ignore: prefer-static-class
void upsertPollAnswer(
  String? choice,
  QuerySnapshot<PollAnswer> snapshot,
  QueryDocumentSnapshot<Poll> pollDoc,
  WidgetRef ref,
) async {
  final Poll poll = pollDoc.data();
  if (DateTime.now().isAfter(poll.openUntil)) {
    throw Exception('Poll is closed');
  }

  final CollectionReference<PollAnswer> answersOfPoll = FirebaseFirestore
      .instance
      .collection('${pollDoc.reference.path}/answers')
      .withConverter<PollAnswer>(
        fromFirestore: (snapshot, _) =>
            PollAnswer.fromJson(snapshot.data() ?? {}),
        toFirestore: (answer, _) => answer.toJson(),
      );

  ref.invalidate(
    currentfirestoreUserFutureProvider,
  ); // Retrieve latest data, in case it changed.
  final userSnapshot =
      await ref.watch(currentfirestoreUserFutureProvider.future);
  final currentUser = userSnapshot.data();
  if (snapshot.size == 0) {
    // ignore: avoid-ignoring-return-values
    await answersOfPoll.add(PollAnswer(
      userId: FirebaseAuth.instance.currentUser?.uid ?? "",
      answer: choice,
      answeredAt: DateTime.now(),
      // User can't be null if using poll feature.
      // ignore: avoid-non-null-assertion
      allergies: poll.question.contains("Eten") ? currentUser.allergies : null,
    ));
  } else {
    await snapshot.docs.first.reference.update({
      'answer': choice,
      'answeredAt': Timestamp.now(),
      if (poll.question.contains(
        "Eten",
      )) // TODO: send allergies only where the poll is of a certain type, not based on the question.
        'allergies':
            // User can't be null if using poll feature.
            // ignore: avoid-non-null-assertion
            currentUser.allergies,
    });
  }
}
