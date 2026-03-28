import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card_subtitle.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_question_form_card_expanded_area.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_session_provider.dart'; // <- your new provider

class SingleQuestionFormCard extends ConsumerWidget {
  const SingleQuestionFormCard({
    super.key,
    required this.formSnapshot,
  });

  final QueryDocumentSnapshot<FirestoreForm> formSnapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(
      formSessionProvider(
        FormSessionParams(
          formId: formSnapshot.id,
          ignoreFilledInForm: false,
        ),
      ),
    );

    return sessionAsync.when(
      data: (session) {
        final form = session.formDoc.data()!;
        final colorScheme = Theme.of(context).colorScheme;

        return ExpansionTile(
          collapsedIconColor: colorScheme.primary,
          title: Text(form.title),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: [
            SingleQuestionFormCardSubtitle(session: session),
            SingleQuestionFormCardExpandedArea(session: session),
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
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
