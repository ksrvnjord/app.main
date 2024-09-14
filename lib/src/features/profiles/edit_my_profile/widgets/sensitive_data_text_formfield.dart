import 'package:flutter/material.dart';

class SensitiveDataTextFormField extends StatelessWidget {
  const SensitiveDataTextFormField({
    super.key,
    required this.title,
    required this.isEditable,
    this.initialValue,
    this.controller,
    this.subtext, // Optional subtext parameter.
  });

  final String title;
  final String? initialValue;
  final bool isEditable;
  final TextEditingController? controller;
  final String? subtext;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: title,
        helperText: subtext, // Add subtext as helper text.
      ),
      enabled: isEditable,
    );
  }
}
