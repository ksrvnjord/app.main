import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/full_form_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormPage extends ConsumerWidget {
  // Constructor which takes a String formId.
  const FormPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formVal = ref.watch(formProvider(formId));
    const double cardPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: ListView(
        children: [
          formVal.when(
            data: (form) => FullFormCard(
              formDoc: form,
            ).padding(all: cardPadding),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (error, stack) =>
                ErrorCardWidget(errorMessage: error.toString()),
          ),
        ],
      ),
    );
  }
}
