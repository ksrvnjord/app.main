import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/poll_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PollCard extends ConsumerWidget {
  const PollCard({
    Key? key,
    required this.pollDoc,
  }) : super(key: key);

  final QueryDocumentSnapshot<Poll> pollDoc;

  void upsertPollAnswer(String? choice, QuerySnapshot<PollAnswer> snapshot) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Poll poll = pollDoc.data();
    final answerStream = ref.watch(pollAnswerProvider(pollDoc.reference));

    return [
      ListTile(
        title: Text(poll.question),
        subtitle: Text(
          'Sluit op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(poll.openUntil)}',
        ),
      ),
      answerStream.when(
        data: (snapshot) {
          final String? answerOfUser =
              snapshot.size != 0 ? snapshot.docs.first.data().answer : null;

          return [
            ...poll.options.map((option) => RadioListTile(
                  toggleable: true,
                  value: option,
                  title: Text(option),
                  onChanged: (String? choice) =>
                      upsertPollAnswer(choice, snapshot),
                  groupValue: answerOfUser,
                )),
          ].toColumn();
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    ].toColumn().card(
          color: Colors.white,
          elevation: 0,
          // add lightblue border
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.lightBlue, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5),
        );
  }
}
