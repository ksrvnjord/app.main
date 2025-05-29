// ignore_for_file: prefer-extracting-function-callbacks, no-magic-string

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card_expanded_area.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card_subtitle.dart';
import 'package:styled_widget/styled_widget.dart';

class SingleQuestionFormCard extends ConsumerStatefulWidget {
  // Constructor which takes a String formId.
  const SingleQuestionFormCard({
    super.key,
    required this.formSnapshot,
  });

  final QueryDocumentSnapshot<FirestoreForm> formSnapshot;

  @override
  createState() => _SingleQuestionFormCardState();
}

class _SingleQuestionFormCardState
    extends ConsumerState<SingleQuestionFormCard> {
  // Constructor which takes a String formId.

  @override
  Widget build(BuildContext context) {
    final form = widget.formSnapshot.data();
    final colorScheme = Theme.of(context).colorScheme;

    return ExpansionTile(
      collapsedIconColor: colorScheme.primary,
      title: Text(form.title),
      subtitle: SingleQuestionFormCardSubtitle(
          form: form, reference: widget.formSnapshot.reference),
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      shape: const RoundedRectangleBorder(side: BorderSide.none),
      children: [
        SingleQuestionFormCardExpandedArea(
          form: form,
          reference: widget.formSnapshot.reference,
        ),
      ],
    ).card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
