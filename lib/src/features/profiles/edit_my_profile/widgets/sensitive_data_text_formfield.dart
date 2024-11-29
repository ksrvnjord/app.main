import 'package:flutter/material.dart';

class SensitiveDataTextFormField extends StatelessWidget {
  const SensitiveDataTextFormField({
    super.key,
    required this.title,
    required this.isEditable,
    this.initialValue,
    this.controller,
    this.helperText, // Optional subtext parameter.
  });

  final String title;
  final String? initialValue;
  final bool isEditable;
  final TextEditingController? controller;
  final String? helperText;
  // ignore: avoid-stateless-widget-initialized-fields
  final maxLines = 3;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: title,
        helperText: helperText,
        helperMaxLines: maxLines, // Add subtext as helper text.
      ),
      enabled: isEditable,
    );
  }
}
