import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_filler.dart';

class FormFiller extends StatelessWidget {
  const FormFiller({
    super.key,
    required this.filler,
    required this.formId,
  });

  final FirestoreFormFiller filler;
  final String formId;

  Future<String?> _getImageUrl() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(
          '$firestoreFormCollectionName/$formId/fillers/${filler.id}',
        );

    try {
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Could not fetch image for filler ${filler.id}: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        const Divider(),
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

        // Body
        Text(
          filler.body,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 12),

        // Image (if available)
        if (filler.hasImage)
          FutureBuilder<String?>(
            future: _getImageUrl(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || snapshot.data == null) {
                return const Center(child: Text('Afbeelding niet beschikbaar'));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.8, // 80% of screen width
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit
                            .contain, // or BoxFit.cover depending on what you want
                      ),
                    ),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
