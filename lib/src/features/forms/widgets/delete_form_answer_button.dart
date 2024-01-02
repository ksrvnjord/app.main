import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';

class DeleteFormAnswerButton extends ConsumerWidget {
  final Function deleteMyFormAnswer;
  final String formId;
  final bool formIsOpen;

  const DeleteFormAnswerButton({
    Key? key,
    required this.deleteMyFormAnswer,
    required this.formId,
    required this.formIsOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(
      formAnswerProvider(formsCollection.doc(formId)),
    );

    return snapshot.when(
      data: (snapshot) {
        return snapshot.size == 0
            ? const SizedBox.shrink()
            : ElevatedButton.icon(
                onPressed: () async {
                  if (formIsOpen == true) {
                    final res = await deleteMyFormAnswer(ref, context);
                    if (res == true) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Formreactie verwijderd!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Form is gesloten, je kan je reactie niet meer verwijderen.'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                icon: const Icon(Icons.delete, size: 12.0),
                label: const Text(
                  "Verwijder Formreactie",
                  style: TextStyle(fontSize: 10),
                ),
              );
      },
      error: (err, stk) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
