import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/object_by_type_and_name.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage store = FirebaseStorage.instance;

Future<void> newDamage(DamageForm damageForm) async {
  // Get the current user ID.
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    throw Exception('DamageForm was submitted by unauthenticated user.');
  }

  // Check if the form is complete
  if (!damageForm.complete) {
    throw Exception('DamageForm was submitted, but not complete.');
  }

  // Get the objects with the given type and name
  final objects = await objectByTypeAndName(damageForm.type!, damageForm.name!);

  // Check if we received any objects
  if (objects.isEmpty) {
    throw Exception('Submitted DamageForm could not find Reservation Object.');
  }

  // Get the first object from the list and receive the subcollections
  final object = objects.first.reference;

  // First create the damages item, so we have an ID
  final addedDamage = await object.collection('damages').add({
    'parent': object,
    'description': damageForm.description,
    'critical': damageForm.critical,
    'createdTime': DateTime.now(),
    'creatorId': uid,
  });

  // Check if there's an image, if so, upload it
  if (damageForm.image != null) {
    final String path =
        '/$uid/public/objects/${object.id}/damages/${addedDamage.id}.jpg';
    await store.ref(path).putFile(
          damageForm.image!,
        );

    // Then, store it in the addedDamage
    addedDamage.update({'image': path});
  }
}
