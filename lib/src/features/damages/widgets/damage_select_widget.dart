import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/all_object_types.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageSelectWidget extends StatelessWidget {
  const DamageSelectWidget({
    Key? key,
  }) : super(key: key);

  final double padding = 16;

  @override
  Widget build(BuildContext context) {
    final formData = context.watch<DamageForm>();

    return FutureWrapper(
      future: reservationObjectsByType(),
      success: (data) => <Widget>[
        DropdownButtonFormField(
          hint: const Text('Selecteer een type...'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          value: formData.type,
          items: data.keys
              .toSet()
              .toList()
              .map<DropdownMenuItem>(
                (key) => DropdownMenuItem(
                  value: key,
                  child: Text(key),
                ),
              )
              .toList(),
          onChanged: (e) => formData.type = e,
        ),
        DropdownButtonFormField<String>(
          hint: const Text('Selecteer een object...'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          value: formData.name,
          items: data.containsKey(formData.type)
              ? data[formData.type]!
                  .map((e) => e.name)
                  .toSet()
                  .map<DropdownMenuItem<String>>(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList()
              : [],
          disabledHint: const Text('Selecteer eerst een type...'),
          onChanged:
              data.containsKey(formData.type) ? (e) => formData.name = e : null,
        ),
      ].toWrap(
        runSpacing: padding,
      ),
    );
  }
}