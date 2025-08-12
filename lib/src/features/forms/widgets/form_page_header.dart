import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/allergy_warning_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPageHeader extends StatelessWidget {
  const FormPageHeader(
      {super.key,
      required this.form,
      required this.answerSnapshot,
      required this.isAFormForUser});

  final FirestoreForm form;
  final QuerySnapshot<FormAnswer> answerSnapshot;
  final bool isAFormForUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final description = form.description;
    const descriptionVPadding = 16.0;
    const leftCardPadding = 8.0;

    final answerExists = answerSnapshot.docs.isNotEmpty;
    final FormAnswer? answer =
        answerExists ? answerSnapshot.docs.first.data() : null;
    final answerIsCompleted = answer?.isCompleted ?? false;
    final isDefinitive = answer?.definitiveAnswerHasBeenGiven ?? false;
    final answerIsUnRetractable = form.formAnswersAreUnretractable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(form.title, style: textTheme.titleLarge),
            ),
            Text(
              '${form.formClosingTimeIsInFuture ? "Sluit" : "Gesloten"} op '
              '${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
              style: textTheme.bodySmall?.copyWith(
                color:
                    form.isOpen ? colorScheme.secondary : colorScheme.outline,
              ),
            ).alignment(Alignment.centerLeft),
          ],
        ),

        if (form.isSoldOut)
          Text(
            "Deze form heeft het maximale aantal antwoorden bereikt",
            style: TextStyle(color: colorScheme.error),
          ).alignment(Alignment.centerLeft),

        if (form.isClosed && form.formClosingTimeIsInFuture)
          Text(
            "Deze form is vroegtijdig gesloten door een admin.",
            style: TextStyle(color: colorScheme.error),
          ).alignment(Alignment.centerLeft),

        if (!isAFormForUser)
          Text(
            "Je hebt geen rechten om deze form in te vullen.",
            style: TextStyle(color: colorScheme.error),
          ).alignment(Alignment.centerLeft),

        if (description != null)
          Text(
            description,
            style: textTheme.bodyMedium,
          )
              .padding(vertical: descriptionVPadding)
              .alignment(Alignment.centerLeft),

        if (form.isKoco)
          GestureDetector(
            onTap: () => context.pushNamed('My Allergies'),
            child: AllergyWarningCard(),
          ),

        if (form.formAnswersAreUnretractable)
          Text(
            "LET OP! Dit formulier is niet meer te wijzigen nadat antwoorden zijn verstuurd. Versturen gebeurt met de knop onderaan het formulier.",
            style: TextStyle(color: colorScheme.error),
          ),

        const SizedBox(height: 16),

        // Answer status
        Row(
          children: [
            Text(
              "Je hebt deze form ",
              style: textTheme.titleMedium,
            ),
            AnswerStatusCard(
              answerExists: answerExists,
              isCompleted: answerIsCompleted,
              showIcon: false,
              isCompleteUnretractableAndUnSent:
                  answerIsCompleted && answerIsUnRetractable && !isDefinitive,
              textStyle: textTheme.titleMedium,
            ).padding(left: leftCardPadding),
          ],
        ),

        if (answerIsCompleted && !form.formAnswersAreUnretractable)
          Text(
            "Je kunt je antwoord nog wijzigen tot de form gesloten is.",
            style: textTheme.bodyMedium,
          ),

        if (answerExists && !answerIsCompleted)
          Text(
            "Vul alle verplichte vragen in om je antwoord te versturen.",
            style: TextStyle(color: colorScheme.error),
          ),
        const SizedBox(
          height: 16,
        ),
        const Divider(),
      ],
    );
  }
}
