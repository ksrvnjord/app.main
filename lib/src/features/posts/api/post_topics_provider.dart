import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postTopicsProvider = FutureProvider<List<String>>((ref) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('postTopics').get();

  // return the 'name' field of each document
  return snapshot.docs.map((e) => e.data()['name'] as String).toList();
});
