import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageFormWidget extends ConsumerWidget {
  const DamageFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(damageFormProvider);
    final diameter = MediaQuery.of(context).size.width;

    const double padding = 16;

    return [
      TextFormField(
        initialValue: formData.description,
        decoration: const InputDecoration(
          hintText: 'Beschrijving',
          border: OutlineInputBorder(),
        ),
        onChanged: (e) => formData.description = e,
      ),
      TextFormField(
        initialValue: formData.cause,
        decoration: const InputDecoration(
          hintText: 'Oorzaak',
          border: OutlineInputBorder(),
        ),
        onChanged: (e) => formData.cause = e,
      ),
      CheckboxListTile(
        value: formData.critical,
        onChanged: (e) => formData.critical = e,
        title: Text(
          'De schade is kritiek, ${formData.name} kan niet meer normaal gebruikt worden',
        ),
      ),
      Text(
        "Upload een foto van de schade indien mogelijk",
        style: Theme.of(context).textTheme.labelLarge,
      ),
      ImagePickerWidget(
        diameter: diameter,
        isEditable: true,
        shouldCrop: true,
        onChange: (e) => formData.image = e,
        shape: ImagePickerWidgetShape.square,
      ),
    ].toColumn(
      separator: const SizedBox(height: padding),
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
