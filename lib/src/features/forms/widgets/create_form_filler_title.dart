import 'package:flutter/material.dart';

class CreateFormFillerTitle extends StatelessWidget {
  const CreateFormFillerTitle({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => (value == null || value.isEmpty)
          ? 'Titelveld kan niet leeg zijn!'
          : null,
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: const InputDecoration(
        hintText: 'Kies een titel voor info-blok.',
        border: InputBorder.none,
      ),
    );
  }
}
