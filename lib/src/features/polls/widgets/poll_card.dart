import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/poll_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/upsert_poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PollCard extends ConsumerWidget {
  const PollCard({
    Key? key,
    required this.pollDoc,
  }) : super(key: key);

  final QueryDocumentSnapshot<Poll> pollDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Poll poll = pollDoc.data();
    final answerStream = ref.watch(pollAnswerProvider(pollDoc.reference));

    final bool pollIsOpen = DateTime.now().isBefore(poll.openUntil);

    const double descriptionHPadding = 16;

    return [
      ListTile(
        title: Text(poll.question),
        subtitle: Text(
          '${pollIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(poll.openUntil)}',
        ),
      ),
      answerStream.when(
        data: (snapshot) {
          final String? answerOfUser =
              snapshot.size != 0 ? snapshot.docs.first.data().answer : null;

          return [
            if (poll.description != null && poll.description!.isNotEmpty)
              Text(poll.description!)
                  .textColor(Colors.blueGrey)
                  .padding(horizontal: descriptionHPadding),
            ...poll.options.map((option) => RadioListTile(
                  value: option,
                  groupValue: answerOfUser,
                  onChanged: pollIsOpen
                      ? (String? choice) =>
                          upsertPollAnswer(choice, snapshot, pollDoc)
                      : null,
                  toggleable: true,
                  title: Text(option),
                )),
          ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    ].toColumn().card(
          color: Colors.white,
          elevation: 0,
          // add lightblue border
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.blueGrey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5),
        );
  }
}
