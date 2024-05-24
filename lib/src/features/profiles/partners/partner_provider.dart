import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/partners/partner.dart';

// ignore: prefer-static-class
final partnerProvider =
    StreamProvider.family<DocumentSnapshot<Partner>, String>((ref, partnerId) {
  return FirebaseFirestore.instance
      .collection('partners')
      .withConverter(
        fromFirestore: (snapshot, _) => Partner.fromJson(snapshot.data() ?? {}),
        toFirestore: (partner, _) => partner.toJson(),
      )
      .doc(partnerId)
      .snapshots();
});
