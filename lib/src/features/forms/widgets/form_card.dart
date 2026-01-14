import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_count_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class FormCard extends ConsumerWidget {
  const FormCard({
    super.key,
    required this.formDoc,
    required this.currentUser,
    this.pushContext = false,
  });

  final DocumentSnapshot<FirestoreForm> formDoc;
  final User currentUser;
  final bool pushContext;

  final borderWidth = 2.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = formDoc.data();

    if (form == null) {
      return const ErrorCardWidget(
        errorMessage: 'Het is niet gelukt om de form te laden',
      );
    }

    final userAnswerProvider = ref.watch(formAnswerProvider(formDoc.reference));

    final countAnswerProvider =
        ref.watch(formAnswerCountProvider(formDoc.reference));

    final colorScheme = Theme.of(context).colorScheme;

    final textTheme = Theme.of(context).textTheme;

    var roundedRectangleBorder = RoundedRectangleBorder(
      side: !form.isOpen
          ? BorderSide(
              color: Colors.grey,
            )
          : userAnswerProvider.when(
              data: (snapshot) => snapshot.docs.isNotEmpty &&
                      // ignore: avoid-unsafe-collection-methods
                      !snapshot.docs.first.data().isCompleted
                  ? BorderSide(
                      color: colorScheme.errorContainer,
                      width: borderWidth,
                    )
                  : BorderSide(color: colorScheme.primary),
              error: (err, stack) => BorderSide(color: colorScheme.primary),
              loading: () => BorderSide(color: colorScheme.primary),
            ),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    );

    return ListTile(
      title: <Widget>[Flexible(child: Text(form.title))]
          .toRow(separator: const SizedBox(width: 4)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            form.formClosingTimeIsInFuture
                ? "Sluit ${timeago.format(
                    form.openUntil,
                    locale: 'nl',
                    allowFromNow: true,
                  )}"
                : "Gesloten op ${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}",
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
          ),
          if (form.maximumNumberIsVisible == true && currentUser.isAdmin)
            countAnswerProvider.when(
              data: (answerCount) => Text(
                "Aantal antwoorden: $answerCount / ${form.maximumNumberOfAnswers < 2000 ? form.maximumNumberOfAnswers : '∞'}",
                style:
                    textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
              ),
              error: (err, stack) =>
                  ErrorTextWidget(errorMessage: err.toString()),
              loading: () => const SizedBox.shrink(),
            ),
          userAnswerProvider.when(
            data: (snapshot) {
              if (snapshot.docs.isEmpty) {
                return const SizedBox.shrink();
              } else {
                final answerExists = snapshot.docs.isNotEmpty;
                final isCompleted = snapshot.docs.first.data().isCompleted;
                final isDefinitive =
                    snapshot.docs.first.data().definitiveAnswerHasBeenGiven;
                return AnswerStatusCard(
                  answerExists: answerExists,
                  isCompleted: snapshot.docs.isNotEmpty &&
                      // ignore: avoid-unsafe-collection-methods
                      snapshot.docs.first.data().isCompleted,
                  showIcon: true,
                  isCompleteUnretractableAndUnSent: isCompleted &&
                      form.formAnswersAreUnretractable &&
                      !isDefinitive,
                  textStyle: textTheme.labelLarge,
                );
              }
            },
            error: (err, stack) =>
                ErrorCardWidget(errorMessage: err.toString()),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: colorScheme.primary),
      onTap: () {
        if (pushContext) {
          context.pushNamed(
            "Form",
            pathParameters: {"formId": formDoc.reference.id},
          );
        } else {
          context.goNamed(
            "Form",
            pathParameters: {"formId": formDoc.reference.id},
          );
        }
      },
    ).card(
      // Transparant color.
      color: Colors.transparent,
      elevation: 0,
      shape: roundedRectangleBorder,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
