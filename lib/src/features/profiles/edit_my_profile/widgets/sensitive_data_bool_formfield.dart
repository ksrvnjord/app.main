import 'package:flutter/material.dart';

class SensitiveDataBoolFormfield extends StatelessWidget {
  const SensitiveDataBoolFormfield({
    super.key,
    required this.title,
    required this.initialValue,
    required this.isEditable,
    this.subtext, // Optional subtext parameter.
  });

  final String title;
  final bool initialValue;
  final bool isEditable;
  final String? subtext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: initialValue,
              onChanged: isEditable ? (bool? newValue) {} : null,
            ),
            Text(title),
          ],
        ),
        if (subtext != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              subtext!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
