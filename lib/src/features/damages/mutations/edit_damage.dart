import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage store = FirebaseStorage.instance;

Future<void> editDamage(
  String id,
  String reservationObjectId,
  DamageForm damageForm,
) async {
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
  final damage = await getDamage(reservationObjectId, id);

  // Update the damage item, using the Damage object / class.
  await damage.reference.update({
    'description': damageForm.description,
    'critical': damageForm.critical,
    'active': true,
    'type': damageForm.type,
    'name': damageForm.name,
  });

  // Check if there's an image, if so, upload it
  if (damageForm.image != null) {
    final String path =
        '/$uid/public/objects/$reservationObjectId/damages/$id.jpg';
    await store.ref(path).putFile(
          damageForm.image!,
        );

    // Then, store it in the addedDamage
    damage.reference.update({'image': path});
  }
}
