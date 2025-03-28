import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/form_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/poll_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/upsert_poll_answer.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PollCard extends ConsumerWidget {
  const PollCard({
    super.key,
    required this.pollDoc,
    this.isExpanded,
  });

  final DocumentSnapshot<Poll> pollDoc;
  final bool? isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Poll? poll = pollDoc.data();
    if (poll == null) {
      return const ErrorCardWidget(
        errorMessage: 'Het is niet gelukt om de poll te laden',
      );
    }

    final String? imagePath = poll.imagePath;
    final answerStream = ref.watch(pollAnswerProvider(pollDoc.reference));

    final bool pollIsOpen = DateTime.now().isBefore(poll.openUntil);

    const double descriptionHPadding = 16;

    final colorScheme = Theme.of(context).colorScheme;

    final description = poll.description;

    final textTheme = Theme.of(context).textTheme;

    const double maxHeight = 240;

    // ignore: arguments-ordering
    return ExpansionTile(
      collapsedIconColor: colorScheme.primary,
      title: Text(poll.question),
      subtitle: [
        Text(
          '${pollIsOpen ? "Sluit" : "Gesloten"} op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(poll.openUntil)}',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
        ),
        answerStream.when(
          data: (snapshot) {
            final bool hasFilledIn = snapshot.size != 0;

            return hasFilledIn
                ? AnswerStatusCard(
                    answerExists: hasFilledIn,
                    // ignore: no-equal-arguments
                    isCompleted: hasFilledIn,
                    showIcon: true,
                    textStyle: textTheme.labelLarge,
                  )
                : const SizedBox.shrink();
          },
          error: (error, stackTrace) => ErrorTextWidget(
              errorMessage: "Antwoorden ophalen mislukt: ${error.toString()}"),
          loading: () => const CircularProgressIndicator.adaptive(),
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      // ignore: avoid-non-null-assertion
      initiallyExpanded: isExpanded != null ? isExpanded! : pollIsOpen,
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
      ),
      children: [
        if (imagePath != null)
          ref.watch(formImageProvider(imagePath)).when(
                data: (data) => data != null
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                          maxHeight: maxHeight,
                        ),
                        child:
                            Image(image: MemoryImage(data), fit: BoxFit.cover),
                      )
                    : const SizedBox.shrink(),
                error: (error, stackTrace) => ErrorCardWidget(
                    errorMessage:
                        "Afbeelding downloaden mislukt ${error.toString()}"),
                loading: () => const CircularProgressIndicator.adaptive(),
              ),
        if (description != null)
          Text(description, style: textTheme.bodyMedium)
              .padding(horizontal: descriptionHPadding),
        answerStream.when(
          data: (snapshot) {
            final String? answerOfUser =
                snapshot.size != 0 ? snapshot.docs.first.data().answer : null;

            return [
              ...poll.options.map((option) => RadioListTile(
                    value: option,
                    groupValue: answerOfUser,
                    onChanged: pollIsOpen
                        ? (String? choice) {
                            upsertPollAnswer(choice, snapshot, pollDoc, ref);
                            // ignore: avoid-ignoring-return-values
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(choice != null
                                  ? 'Je keuze is opgeslagen'
                                  : 'Je keuze is verwijderd'),
                            ));
                          }
                        : null,
                    toggleable: true,
                    title: Text(option),
                  )),
            ].toColumn();
          },
          error: (error, stackTrace) => ErrorCardWidget(
              errorMessage: "Antwoord laden mislukt: ${error.toString()}"),
          loading: () => const CircularProgressIndicator.adaptive(),
        ),
      ],
    ).card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      // Transparant color.
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
