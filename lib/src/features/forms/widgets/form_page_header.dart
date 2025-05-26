import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/allergy_warning_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/routing_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPageHeader extends StatelessWidget {
  const FormPageHeader({super.key, required this.form, required this.answer});

  final FirestoreForm form;
  final QuerySnapshot<FormAnswer> answer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final description = form.description;
    const descriptionVPadding = 16.0;
    const leftCardPadding = 8.0;

    final answerExists = answer.docs.isNotEmpty;
    final answerIsCompleted = answerExists &&
        // ignore: avoid-unsafe-collection-methods
        answer.docs.first.data().isCompleted;

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
            IconButton(
              onPressed: () {
                const snackbar = SnackBar(
                  content:
                      Text('Er is iets misgegaan bij het delen van de form'),
                );
                final RouteInformation routeInfo =
                    GoRouter.of(context).routeInformationProvider.value;
                final state = routeInfo.state as Map<Object?, Object?>?;
                if (state == null) {
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  return;
                }
                final currentPath = state['location'] as String;
                final url = "${RoutingConstants.appBaseUrl}$currentPath";
                Share.share(url).ignore();
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),

        Text(
          '${form.formClosingTimeIsInFuture ? "Sluit" : "Gesloten"} op '
          '${DateFormat('EEEE d MMMM y HH:mm', 'nl_NL').format(form.openUntil)}',
          style: textTheme.bodySmall?.copyWith(
            color: form.userCanEditForm
                ? colorScheme.secondary
                : colorScheme.outline,
          ),
        ).alignment(Alignment.centerLeft),

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

        if (description != null)
          Text(description, style: textTheme.bodyMedium)
              .padding(vertical: descriptionVPadding)
              .alignment(Alignment.centerLeft),

        if (form.isKoco)
          GestureDetector(
            onTap: () => context.pushNamed('My Allergies'),
            child: AllergyWarningCard(),
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
              textStyle: textTheme.titleMedium,
            ).padding(left: leftCardPadding),
          ],
        ),
        if (answerIsCompleted)
          Text(
            "Je kunt je antwoord nog wijzigen tot de form gesloten is.",
            style: textTheme.bodyMedium,
          ),
        if (answerExists && !answerIsCompleted)
          Text(
            "Vul alle verplichte vragen in om je antwoord te versturen.",
            style: TextStyle(color: colorScheme.error),
          ),
      ],
    );
  }
}
