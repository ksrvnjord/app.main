import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll_answer.dart';

void upsertPollAnswer(
  String? choice,
  QuerySnapshot<PollAnswer> snapshot,
  DocumentSnapshot<Poll> pollDoc,
) {
  final CollectionReference<PollAnswer> answersOfPoll = FirebaseFirestore
      .instance
      .collection('${pollDoc.reference.path}/answers')
      .withConverter<PollAnswer>(
        fromFirestore: (snapshot, _) => PollAnswer.fromJson(snapshot.data()!),
        toFirestore: (answer, _) => answer.toJson(),
      );
  if (snapshot.size == 0) {
    answersOfPoll.add(PollAnswer(
      userId: FirebaseAuth.instance.currentUser!.uid,
      answer: choice,
      answeredAt: DateTime.now(),
    ));
  } else {
    snapshot.docs.first.reference.update({
      'answer': choice,
      'answeredAt': Timestamp.now(),
    });
  }
}
