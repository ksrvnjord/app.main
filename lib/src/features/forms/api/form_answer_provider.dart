import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';

// ignore: prefer-static-class
final formAnswerProvider = StreamProvider.family<QuerySnapshot<FormAnswer>,
    DocumentReference<FirestoreForm>>((ref, docRef) {
  final user = ref.watch(firebaseAuthUserProvider).value;

  return user == null
      ? const Stream.empty()
      : FirebaseFirestore.instance
          .collection('${docRef.path}/answers')
          .withConverter<FormAnswer>(
            fromFirestore: (snapshot, _) =>
                FormAnswer.fromJson(snapshot.data() ?? {}),
            toFirestore: (answer, _) => answer.toJson(),
          )
          .where('userId', isEqualTo: user.uid)
          .snapshots();
});
