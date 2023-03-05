import 'package:flutter/material.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageFormWidget extends StatelessWidget {
  const DamageFormWidget({
    Key? key,
  }) : super(key: key);

  final double padding = 16;

  @override
  Widget build(BuildContext context) {
    final formData = context.watch<DamageForm>();
    final diameter = MediaQuery.of(context).size.width;

    return Wrap(
      runSpacing: padding,
      children: [
        TextFormField(
          initialValue: formData.description,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Beschrijving',
          ),
          onChanged: (e) => formData.description = e,
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
          onChange: (e) => formData.image = e,
          shape: ImagePickerWidgetShape.square,
          isEditable: true,
          shouldCrop: true,
        ).center(),
      ],
    );
  }
}
