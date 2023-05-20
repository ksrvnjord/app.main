import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageFormWidget extends ConsumerWidget {
  const DamageFormWidget({
    Key? key,
  }) : super(key: key);

  final double padding = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(damageFormProvider);
    final diameter = MediaQuery.of(context).size.width;

    return Wrap(
      runSpacing: padding,
      children: [
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
        Row(children: [
          Checkbox(
            value: formData.critical,
            onChanged: (e) => formData.critical = e,
          ),
          const Text('Direct uit de vaart halen?'),
        ]),
        ImagePickerWidget(
          diameter: diameter,
          isEditable: true,
          shouldCrop: true,
          onChange: (e) => formData.image = e,
          shape: ImagePickerWidgetShape.square,
        ).center(),
      ],
    );
  }
}
