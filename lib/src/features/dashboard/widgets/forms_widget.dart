import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_polls_combination_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/widgets/poll_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({
    super.key,
  });

  Widget _buildOpenFormsList(List<Object> forms, BuildContext context) {
    if (forms.isEmpty) {
      return const Text("Geen open forms op dit moment")
          .textColor(Theme.of(context).colorScheme.secondary);
    }

    const hPadding = 8.0;

    return [
      ...forms.map((item) {
        switch (item.runtimeType.toString()) {
          // Unfortunate workaround for the fact that the type of the item is not a known type.
          case "_WithConverterQueryDocumentSnapshot<FirestoreForm>":
            return FormCard(
              formDoc: item as QueryDocumentSnapshot<FirestoreForm>,
            );

          case "_WithConverterQueryDocumentSnapshot<Poll>":
            return PollCard(pollDoc: item as QueryDocumentSnapshot<Poll>);

          default:
            return const ErrorCardWidget(errorMessage: "Onbekend formtype");
        }
      }),
    ].toColumn().padding(horizontal: hPadding);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is the provider that combines the forms and polls (legacy).
    // TODO: Remove this after migration of all the polls to forms.
    final openForms = ref.watch(openFormsPollsCombinationProvider);

    return [
      WidgetHeader(
        title: "Forms",
        titleIcon: Icons.edit_document,
        onTapName: "Alle forms",
        onTap: () => context.goNamed(RouteName.forms),
      ),
      openForms.when(
        data: (data) => _buildOpenFormsList(data, context),
        error: (error, stack) => Text(
          error.toString(),
        ),
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    ].toColumn();
  }
}
