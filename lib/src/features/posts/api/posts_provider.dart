// ignore_for_file: prefer-static-class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';

import '../model/post.dart';

final postsCollection =
    FirebaseFirestore.instance.collection('posts').withConverter<Post>(
          fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data() ?? {}),
          toFirestore: (post, _) => post.toJson(),
        );

final postProvider =
    StreamProvider.family.autoDispose<DocumentSnapshot<Post>, String>(
  (ref, docId) {
    // ignore: avoid-ignoring-return-values
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      return const Stream.empty();
    }

    return postsCollection.doc(docId).snapshots();
  },
);

final postsProvider =
    StreamProvider.family.autoDispose<QuerySnapshot<Post>, String?>(
  (ref, topic) {
    // ignore: avoid-ignoring-return-values
    ref.watch(firebaseAuthUserProvider);

    return topic == null
        ? postsCollection.orderBy('createdTime', descending: true).snapshots()
        : postsCollection
            .where('topic', isEqualTo: topic)
            .orderBy('createdTime', descending: true)
            .snapshots();
  },
);
