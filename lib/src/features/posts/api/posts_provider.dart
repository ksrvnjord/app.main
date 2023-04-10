import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/post.dart';

final postsCollection =
    FirebaseFirestore.instance.collection('posts').withConverter<Post>(
          fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
          toFirestore: (post, _) => post.toJson(),
        );

// retrieves posts for a given topic
final postsProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<Post>, String>((ref, topic) {
  return postsCollection
      .where('topic', isEqualTo: topic)
      .where(
        'createdTime',
        isGreaterThan: DateTime.now().subtract(const Duration(days: 14)),
      )
      .orderBy('createdTime', descending: true)
      .snapshots();
});

final postProvider =
    StreamProvider.autoDispose.family<DocumentSnapshot<Post>, String>(
  (ref, docId) {
    return postsCollection.doc(docId).snapshots();
  },
);
