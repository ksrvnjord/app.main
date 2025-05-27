import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_filler.dart';

class FormFiller extends StatelessWidget {
  const FormFiller({
    super.key,
    required this.filler,
  });

  final FirestoreFormFiller filler;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title - centered, bold, larger font
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            filler.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Body - left aligned, normal font size
        Text(
          filler.body,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
