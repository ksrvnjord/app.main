import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/upsert_form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormQuestion extends ConsumerWidget {
  const FormQuestion({
    Key? key,
    required this.question,
    required this.formPath,
    required this.formDoc,
  }) : super(key: key);

  final Map<String, dynamic> question;

  final String formPath;

  final DocumentSnapshot<FirestoreForm> formDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final type = question['Type'];

    final List<Widget> questionWidgets = [
      Text(
        question['Label'],
        style: textTheme.titleLarge,
      ),
    ];

    switch (type) {
      case 'TEXT':
        questionWidgets.add(
          TextFormField(
            onFieldSubmitted: (String value) => {
              upsertFormAnswer(
                value,
                question['Label'],
                formDoc,
                ref,
              ),
            },
          ).padding(horizontal: 64),
        );
        break;
      // case 'Multiplechoice':
      //   [...question['Choices'].map((choice) => questionWidgets.add(RadioListTile(
      //               value: choice,
      //               groupValue: answerOfUser,
      //               onChanged: pollIsOpen
      //                   ? (String? choice) {
      //                       upsertPollAnswer(choice, snapshot, pollDoc, ref);
      //                       // ignore: avoid-ignoring-return-values
      //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                         content: Text(choice != null
      //                             ? 'Je keuze is opgeslagen'
      //                             : 'Je keuze is verwijderd'),
      //                       ));
      //                     }
      //                   : null,
      //               toggleable: true,
      //               title: Text(option),)))];

      //   break;
      default:
        return const ErrorCardWidget(
          errorMessage: 'Onbekend type vraag',
        );
    }

    return questionWidgets.toColumn();
  }
}
