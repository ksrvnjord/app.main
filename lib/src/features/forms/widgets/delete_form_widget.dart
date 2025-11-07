import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:styled_widget/styled_widget.dart';

class DeleteFormButton extends StatelessWidget {
  const DeleteFormButton({super.key, required this.formId});
  final String formId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (innerContext) => AlertDialog(
            title: const Text('Verwijderen'),
            content: const Text(
              'Weet je zeker dat je deze form wilt verwijderen?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(innerContext).pop(),
                child: const Text('Annuleren'),
              ),
              TextButton(
                onPressed: () async {
                  if (innerContext.mounted) {
                    Navigator.of(innerContext).pop();
                  }

                  try {
                    final formPath = FirebaseFirestore.instance
                        .doc('$firestoreFormCollectionName/$formId')
                        .path;
                    await FormRepository.deleteForm(formPath);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Formulier succesvol verwijderd')),
                      );
                      context.pop(); // pop the current page if needed
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fout bij verwijderen: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Verwijderen').textColor(Colors.red),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.delete),
    );
  }
}
