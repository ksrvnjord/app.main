// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/huis_info.dart';

// ignore: prefer-static-class
final huisInfoProvider =
    FutureProvider.autoDispose.family<HuisInfo, String>((ref, name) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('group_info')
      .withConverter<HuisInfo>(
        fromFirestore: (snapshot, _) => HuisInfo.fromMap(snapshot.data() ?? {}),
        toFirestore: (HuisInfo huisInfo, _) => huisInfo.toMap(),
      )
      .where('name', isEqualTo: name)
      .get();

  return snapshot.docs.first.data();
});

// ignore: prefer-static-class
final huisDescriptionProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, name) async {
  final huis = await ref.watch(huisInfoProvider(name).future);

  return huis.description;
});
