import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';

class CreateFormNameAndDescriptionWidget extends ConsumerWidget {
  const CreateFormNameAndDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    // Logic for admin vs regular user can go here
    return Column(children: [
      TextFormField(
        // Kies form naam.
        controller: state.formName,
        decoration: const InputDecoration(labelText: 'Formulier naam'),
        maxLines: null,

        validator: (value) => (value == null || value.isEmpty)
            ? 'Naam van de form kan niet leeg zijn.'
            : null,
      ),
      TextFormField(
        // Kies beschrijving form.
        controller: state.description,
        decoration: const InputDecoration(
          labelText: 'Beschrijving form',
        ),
        maxLines: null,
      ),
    ]);
  }
}
