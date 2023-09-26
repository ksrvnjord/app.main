import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/poll_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/upsert_poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({
    super.key,
  });

  Widget _buildOpenPollsList(
    QuerySnapshot<Poll> polls,
    WidgetRef ref,
    BuildContext context,
  ) {
    if (polls.size == 0) {
      return const Text("Geen open forms op dit moment")
          .textColor(Theme.of(context).colorScheme.secondary);
    }
    final docs = polls.docs;
    final first = docs.first;
    const double descriptionHPadding = 16;

    return [
      ...docs.map((doc) {
        final Poll poll = doc.data();
        final answerStream = ref.watch(pollAnswerProvider(doc.reference));
        final description = poll.description;

        final textTheme = Theme.of(context).textTheme;

        return ExpansionTile(
          title: Text(
            poll.question,
          ),
          subtitle: Text(
            'Sluit op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(poll.openUntil)}',
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          // ignore: sort_child_properties_last
          children: [
            if (description != null)
              Text(
                description,
                style: textTheme.bodyMedium,
              ).padding(horizontal: descriptionHPadding),
            answerStream.when(
              data: (snapshot) {
                final String? answerOfUser = snapshot.size != 0
                    ? snapshot.docs.first.data().answer
                    : null;

                return [
                  ...poll.options.map((option) => RadioListTile(
                        value: option,
                        groupValue: answerOfUser,
                        // ignore: prefer-extracting-callbacks
                        onChanged: (String? choice) {
                          upsertPollAnswer(choice, snapshot, doc, ref);
                          // ignore: avoid-ignoring-return-values
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(choice != null
                                  ? 'Je keuze is opgeslagen'
                                  : 'Je keuze is verwijderd'),
                            ),
                          );
                        },
                        toggleable: true,
                        title: Text(option),
                      )),
                ].toColumn();
              },
              error: (error, stackTrace) => const ErrorCardWidget(
                errorMessage: 'Het is mislukt om je antwoord te laden',
              ),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
          initiallyExpanded: doc == first,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 0),
          ),
        ).card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 0,
          // Transparant color.
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        );
      }),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openPolls = ref.watch(openPollsProvider);
    final user = ref.watch(firebaseAuthUserProvider);
    final authenticated = (user != null);

    return [
      WidgetHeader(
        title: "Forms",
        titleIcon: Icons.edit_document,
        onTapName: "Alle forms",
        onTap:
            authenticated ? () => Routemaster.of(context).push('polls') : null,
      ),
      authenticated
          ? openPolls.when(
              data: (data) => _buildOpenPollsList(data, ref, context),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text(
                error.toString(),
              ),
            )
          : const Text("Geen open forms op dit moment")
              .textColor(Theme.of(context).colorScheme.secondary),
    ].toColumn();
  }
}
