import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/select_group_widget.dart';

class CreateFormOptionsWidget extends ConsumerWidget {
  const CreateFormOptionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    // Logic for admin vs regular user can go here
    return Column(children: [
      Row(
        children: [
          Checkbox.adaptive(
            value: state.hasMaximumNumberOfAnswers,
            onChanged: (bool? value) {
              state.updateHasMaximumNumberOfAnswers(value);
            },
          ),
          const Text('Maximum aantal antwoorden toestaan'),
        ],
      ),
      if (state.hasMaximumNumberOfAnswers)
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Maximum aantal antwoorden',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            state.updateMaximumNumberOfAnswers(int.tryParse(value));
          },
          validator: (value) {
            if (state.hasMaximumNumberOfAnswers &&
                (value == null || value.isEmpty)) {
              return 'Vul het maximum aantal antwoorden in.';
            }
            return null;
          },
        ), //TODO disable feature later
      Row(
        children: [
          Checkbox.adaptive(
            value: state.maximumNumberOfAnswersIsVisible,
            onChanged: (bool? value) {
              state.updateMaximumNumberOfAnswersIsVisible(value);
            },
          ),
          const Text('Maximum aantal antwoorden tonen in de app'),
        ],
      ),
      SelectGroupWidget(),
    ]);
  }
}
