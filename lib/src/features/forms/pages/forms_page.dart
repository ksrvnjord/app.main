import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_polls_combination_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/widgets/poll_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsPage extends ConsumerWidget {
  const FormsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formsAndPolls = ref.watch(formsPollsCombinationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          formsAndPolls.when(
            data: (data) {
              return data
                  .map((item) {
                    switch (item.runtimeType.toString()) {
                      // Unfortunate workaround for the fact that the type of the item is not a known type.
                      case "_WithConverterQueryDocumentSnapshot<FirestoreForm>":
                        return FormCard(
                          formDoc: item as QueryDocumentSnapshot<FirestoreForm>,
                        );
                      case "_WithConverterQueryDocumentSnapshot<Poll>":
                        return PollCard(
                          pollDoc: item as QueryDocumentSnapshot<Poll>,
                        );
                      default:
                        return const ErrorCardWidget(
                          errorMessage: "Onbekend formtype",
                        );
                    }
                  })
                  .toList()
                  .toColumn(separator: const SizedBox(height: 4));
            },
            error: (error, stack) => Text(error.toString()),
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ],
      ),
    );
  }
}
