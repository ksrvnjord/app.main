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

class FullFormCard extends ConsumerWidget {
  const FullFormCard({
    Key? key,
    required this.question,
    required this.formPath,
  }) : super(key: key);

  final Map<String, dynamic> question;

  final String formPath;

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

    final Map<String, String?> answerWidgets = {
      "Label": question['Label'],
      "Value": null,
    };

    switch (type) {
      case 'TEXT':
        questionWidgets.add(
          TextFormField(
              onTap: () => debugPrint(answerWidgets["Value"] ?? "null"),
              onFieldSubmitted: (String value) => {
                    answerWidgets["Value"] = value,
                    UpdateAnswer(answerWidgets),
                  },
              onSaved: (value) {
                debugPrint("onSaved");
              }).padding(horizontal: 64),
        );
        break;
      case 'Multiplechoice':
      default:
        return const ErrorCardWidget(
          errorMessage: 'Onbekend type vraag',
        );
    }

    return questionWidgets.toColumn();
  }
}

UpdateAnswer(Map<String, String?> answerWidgets) {
  debugPrint("Updated answer to ${answerWidgets["Value"] ?? "null"} ");
}

