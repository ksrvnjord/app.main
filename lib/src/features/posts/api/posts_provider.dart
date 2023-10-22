// ignore_for_file: prefer-static-class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/post.dart';

final postsCollection =
    FirebaseFirestore.instance.collection('posts').withConverter<Post>(
          fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data() ?? {}),
          toFirestore: (post, _) => post.toJson(),
        );

final postProvider =
    StreamProvider.family.autoDispose<DocumentSnapshot<Post>, String>(
  (ref, docId) {
    return postsCollection.doc(docId).snapshots();
  },
);

final postQueryProvider = Provider.family.autoDispose<Query<Post>, String?>(
  (ref, topic) {
    return topic == null
        ? postsCollection.orderBy('createdTime', descending: true)
        : postsCollection
            .where('topic', isEqualTo: topic)
            .orderBy('createdTime', descending: true);
  },
);
