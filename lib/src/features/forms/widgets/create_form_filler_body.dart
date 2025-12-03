import 'package:flutter/material.dart';

class CreateFormFillerBody extends StatelessWidget {
  const CreateFormFillerBody({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => (value == null || value.isEmpty)
          ? 'Contentveld kan niet leeg zijn!'
          : null,
      controller: controller,
      textAlign: TextAlign.left,
      maxLines: null,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        hintText: 'Ruimte voor uitleg, prijzen, disclaimers etc...',
        border: InputBorder.none,
      ),
    );
  }
}
