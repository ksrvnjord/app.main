import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/select_group_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class CreateFormOptionsWidget extends ConsumerWidget {
  const CreateFormOptionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    final currentUserAsync = ref.watch(currentUserProvider);
    // Logic for admin vs regular user can go here
    return Column(children: [
      SizedBox(
        height: 16,
      ),
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
          initialValue: state.maximumNumberOfAnswers.toString(),
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
        ),
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
      Row(
        children: [
          Checkbox.adaptive(
            value: state.formAnswersAreUntretractable,
            onChanged: (bool? value) {
              state.updateFormAnswersAreUntretractable(value);
            },
          ),
          const Text('Formulierantwoorden direct definitief maken'),
        ],
      ),
      currentUserAsync.when(
        data: (user) {
          return Row(
            children: [
              AbsorbPointer(
                  absorbing: !user.isAdmin,
                  child: Checkbox.adaptive(
                    value: state.isDraft,
                    onChanged: (bool? value) {
                      state.updateIsDraft(value);
                    },
                    activeColor: user.isAdmin ? null : Colors.grey,
                  )),
              const Text('Form is een concept'),
            ],
          );
        },
        loading: () {
          return const CircularProgressIndicator.adaptive();
        },
        error: (error, stack) =>
            ErrorCardWidget(errorMessage: error.toString()),
      ),
    ]);
  }
}
