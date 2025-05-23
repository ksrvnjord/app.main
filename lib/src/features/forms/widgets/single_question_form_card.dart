// ignore_for_file: prefer-extracting-function-callbacks, no-magic-string

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/can_edit_form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_count_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/allergy_warning_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/answer_status_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card_expanded_area.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card_subtitle.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    final textTheme = Theme.of(context).textTheme;

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
