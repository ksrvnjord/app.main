import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';

// ignore: prefer-static-class
void upsertFormAnswer(
  String? value, // Given answer
  int questionNumber,
  QuerySnapshot<FormAnswer> answerSnapshot, // Who, what, when
  DocumentSnapshot<FirestoreForm> formDoc,
  WidgetRef ref,
  // String formPath,
) async {
  final FirestoreForm? form = formDoc.data();
  if (form == null) {
    throw Exception('Form is null');
  }

  if (DateTime.now().isAfter(form.openUntil)) {
    throw Exception('Form is closed');
  }

  final CollectionReference<FormAnswer> answersOfForm = FirebaseFirestore
      .instance
      .collection('${formDoc.reference.path}/answers')
      .withConverter<FormAnswer>(
        fromFirestore: (snapshot, _) =>
            FormAnswer.fromJson(snapshot.data() ?? {}),
        toFirestore: (answer, _) => answer.toJson(),
      );

  final userSnapshot = ref.watch(currentfirestoreUserStreamProvider);
  final currentUser = userSnapshot.value?.docs.first.data();
  if (currentUser == null) {
    throw Exception('Firestore User is null');
  }

  final questionAnswers = answersOfForm
      .doc('dNmZiwY7bWFS5v2Wdi69')
      .get()
      .then((e) => e.data().answers);

  final bool hasAnswered = answerSnapshot.size != 0;
  if (!hasAnswered) {
    // On first answer, add the answer to the collection.
    // ignore: avoid-ignoring-return-values
    answersOfForm[questionNumber]["Value"] = value;

    await answersOfForm.add(FormAnswer(
      userId: FirebaseAuth.instance.currentUser?.uid ?? "",
      answers: value,
      answeredAt: DateTime.now(),
      // User can't be null if using form feature.
      // ignore: avoid-non-null-assertion
      allergies: form.formName.contains("Eten") ? currentUser.allergies : null,
    ));

    return;
  } else if (hasAnswered && value == null) {
    // On undo, delete the answer from the collection.
    await answerSnapshot.docs.first.reference.delete();

    return;
  } else {
    // User picked a different answer.
    await answerSnapshot.docs.first.reference.update({
      'answer': value,
      'answeredAt': Timestamp.now(),
      if (form.formName.contains(
        "Eten",
      )) // TODO: send allergies only where the form is of a certain type, not based on the question.
        'allergies':
            // User can't be null if using form feature.
            // ignore: avoid-non-null-assertion
            currentUser.allergies,
    });
  }
}
