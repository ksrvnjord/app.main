import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_author_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_date_time_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_name_and_description_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_options_widget.dart';

class CreateFormMetaFieldsWidget extends ConsumerWidget {
  const CreateFormMetaFieldsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    const sizedBoxHeight = 16.0;
    // Logic for admin vs regular user can go here
    return Column(children: [
      Center(
        child: Text('Formulierinformatie',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      const Divider(
        thickness: 6,
      ),
      CreateFormAuthorWidget(),
      CreateFormNameAndDescriptionWidget(),
      const SizedBox(height: sizedBoxHeight),
      CreateFormDateTimePicker(
        initialDate: state.openUntil,
        onDateTimeChanged: (DateTime dateTime) =>
            state.updateOpenUntil(dateTime),
      ),
      CreateFormOptionsWidget(),
      const SizedBox(
        height: 32,
      ),
    ]);
  }
}
