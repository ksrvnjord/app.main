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
  ); // Retrieve latest allergies data, in case it changed.
  final userSnapshot =
      await ref.watch(currentfirestoreUserFutureProvider.future);
  final currentUser = userSnapshot.data();

  final bool hasAnswered = snapshot.size != 0;
  if (!hasAnswered) {
    // On first answer, add the answer to the collection.
    // ignore: avoid-ignoring-return-values
    await answersOfPoll.add(PollAnswer(
      userId: FirebaseAuth.instance.currentUser?.uid ?? "",
      answer: choice,
      answeredAt: DateTime.now(),
      // User can't be null if using poll feature.
      // ignore: avoid-non-null-assertion
      allergies: poll.question.contains("Eten") ? currentUser.allergies : null,
    ));

    return;
  } else if (hasAnswered && choice == null) {
    // On undo, delete the answer from the collection.
    await snapshot.docs.first.reference.delete();

    return;
  } else {
    // User picked a different answer.
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
