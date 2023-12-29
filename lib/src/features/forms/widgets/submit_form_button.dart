import 'package:flutter/material.dart';

class SubmitFormButton extends StatelessWidget {
  const SubmitFormButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null, // Add your onPressed method here
      child: Text('Opslaan'),
    );
  }
}
