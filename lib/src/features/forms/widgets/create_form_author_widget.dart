import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';

class CreateFormAuthorWidget extends ConsumerWidget {
  const CreateFormAuthorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    // Logic for admin vs regular user can go here
    return currentUserAsync.when(
      data: (user) {
        if (state.author.text.isEmpty) {
          state.author.text = user.isBestuur
              ? user.fullName
              : user.canCreateFormsFor.keys.firstOrNull ?? user.fullName;
        }
        return DropdownButtonFormField<String>(
          value: state.author.text,
          decoration: const InputDecoration(labelText: 'Auteur'),
          items: [
            ...user.canCreateFormsFor.entries.map((entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value))),
            if (user.isAdmin)
              DropdownMenuItem(
                value: user.fullName,
                child: Text(user.fullName),
              ),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              state.updateAuthor(newValue);
            }
          },
          validator: (value) => (value == null || value.isEmpty)
              ? 'Auteur kan niet leeg zijn.'
              : null,
        );
      },
      loading: () {
        return const CircularProgressIndicator.adaptive();
      },
      error: (error, stack) => ErrorTextWidget(errorMessage: error.toString()),
    );
  }
}
