import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleQuestionFormCardSubtitle extends ConsumerWidget {
  const SingleQuestionFormCardSubtitle({super.key, required this.session});

  final FormSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final form = session.formDoc.data()!;
    final answerRef = session.answerDocRef;

    if (answerRef == null) {
      // If there is no answer reference, just show nothing or a placeholder
      return const SizedBox.shrink();
    }

    final userAnswerProvider =
        ref.watch(formAnswerProvider(session.formDoc.reference));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (form.isSoldOut)
          Text(
            "Uitverkocht/Volgeboekt",
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          )
        else
          Text(
            form.formClosingTimeIsInFuture && !form.isClosed
                ? "Sluit ${timeago.format(form.openUntil, locale: 'nl', allowFromNow: true)}"
                : !form.formClosingTimeIsInFuture
                    ? "Gesloten op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}"
                    : "Gesloten",
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
          ),
        userAnswerProvider.when(
          data: (snapshot) {
            if (snapshot.docs.isEmpty) return const SizedBox.shrink();

            final answer = snapshot.docs.first.data();
            final answerExists = true;
            final isCompleted = answer.isCompleted;
            final isDefinitive = answer.definitiveAnswerHasBeenGiven;

            return AnswerStatusCard(
              answerExists: answerExists,
              isCompleted: isCompleted,
              showIcon: true,
              isCompleteUnretractableAndUnSent: isCompleted &&
                  form.formAnswersAreUnretractable &&
                  !isDefinitive,
              textStyle: textTheme.labelLarge,
            );
          },
          error: (err, stack) => ErrorTextWidget(errorMessage: err.toString()),
          loading: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
