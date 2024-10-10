import 'package:flutter/material.dart';

class SensitiveDataBoolFormfield extends StatelessWidget {
  const SensitiveDataBoolFormfield({
    super.key,
    required this.title,
    this.valueNotifier,
    this.initialValue,
    required this.isEditable,
    this.subtext, // Optional subtext parameter.
  });

  final String title;
  final ValueNotifier<bool>? valueNotifier;
  final bool? initialValue;
  final bool isEditable;
  final String? subtext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isEditable && valueNotifier != null)
              ValueListenableBuilder<bool>(
                // ignore: avoid-non-null-assertion
                valueListenable: valueNotifier!,
                builder: (builderContext, value, child) {
                  return Checkbox(
                    value: value,
                    // ignore: prefer-extracting-callbacks
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        // ignore: avoid-non-null-assertion
                        valueNotifier!.value = newValue;
                      }
                    },
                  );
                },
              )
            else
              Checkbox(value: initialValue ?? false, onChanged: null),
            Text(title),
          ],
        ),
        if (subtext != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              // ignore: avoid-non-null-assertion
              subtext!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
