// ignore_for_file: prefer-static-class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';

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

// Retrieves posts for a given topic.
final postsProvider = StreamProvider.autoDispose<QuerySnapshot<Post>>((ref) {
  if (ref.watch(firebaseAuthUserProvider).value != null) {
    final String? topic = ref.watch(selectedTopicProvider);
    const int amountOfPosts = 30;

    return topic == null
        ? postsCollection
            .orderBy('createdTime', descending: true)
            .limit(amountOfPosts)
            .snapshots()
        : postsCollection
            .where('topic', isEqualTo: topic)
            .orderBy("createdTime", descending: true)
            .limit(amountOfPosts)
            .snapshots();
  } else {
    return const Stream.empty();
  }
});
