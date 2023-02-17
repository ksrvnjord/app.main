import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/user_id.dart';

final CollectionReference<AlmanakProfile> people = FirebaseFirestore.instance
    .collection('people')
    .withConverter<AlmanakProfile>(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

Future<AlmanakProfile> getFirestoreProfileData(String userId) async {
  QuerySnapshot<AlmanakProfile> profile =
      await people.where('identifier', isEqualTo: userId).get();

  return profile.docs.first.data();
}

Future<AlmanakProfile> getMyFirestoreProfileData() {
  return getFirestoreProfileData(getCurrentUserId());
}
