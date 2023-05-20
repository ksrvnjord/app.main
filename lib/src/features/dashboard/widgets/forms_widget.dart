import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/poll_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/upsert_poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({
    super.key,
  });

  Widget _buildOpenPollsList(QuerySnapshot<Poll> polls, WidgetRef ref) {
    if (polls.size == 0) {
      return const Text("Geen open forms op dit moment").textColor(Colors.grey);
    }
    final docs = polls.docs;
    final first = docs.first;
    const double descriptionHPadding = 16;

    return [
      ...docs.map((doc) {
        final Poll poll = doc.data();
        final answerStream = ref.watch(pollAnswerProvider(doc.reference));

        return ExpansionTile(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 0),
          ),
          initiallyExpanded: doc == first, // expand first poll
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(poll.question),
          subtitle: Text(
            'Sluit op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(poll.openUntil)}',
          ).textColor(Colors.grey),
          children: [
            if (poll.description != null)
              Text(poll.description!)
                  .textColor(Colors.blueGrey)
                  .padding(horizontal: descriptionHPadding),
            answerStream.when(
              data: (snapshot) {
                final String? answerOfUser = snapshot.size != 0
                    ? snapshot.docs.first.data().answer
                    : null;

                return [
                  ...poll.options.map((option) => RadioListTile(
                        toggleable: true,
                        value: option,
                        title: Text(option),
                        onChanged: (String? choice) =>
                            upsertPollAnswer(choice, snapshot, doc),
                        groupValue: answerOfUser,
                      )),
                ].toColumn();
              },
              error: (error, stackTrace) => const ErrorCardWidget(
                errorMessage: 'Het is mislukt om je antwoord te laden',
              ),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        );
      }),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openPolls = ref.watch(openPollsProvider);

    return [
      WidgetHeader(
        title: "Open forms",
        onTapName: "Alle forms",
        onTap: () => Routemaster.of(context).push('polls'),
      ),
      openPolls.when(
        data: (data) => _buildOpenPollsList(data, ref),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text(
          error.toString(),
        ),
      ),
    ].toColumn();
  }
}
