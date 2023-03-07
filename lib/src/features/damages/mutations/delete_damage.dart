import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage store = FirebaseStorage.instance;

Future<void> deleteDamage(
  String id,
  String reservationObjectId,
) async {
  // Get the current user ID.
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    throw Exception('DamageForm was submitted by unauthenticated user.');
  }

  // Get the damage using the identifiers
  final damage = await getDamage(reservationObjectId, id);

  // Check if there's an image, if so, delete it
  if (damage.data()?.image != null) {
    final String path =
        '/$uid/public/objects/$reservationObjectId/damages/$id.jpg';
    await store.ref(path).delete();
  }

  // First create the damages item, so we have an ID
  return await damage.reference.delete();
}
