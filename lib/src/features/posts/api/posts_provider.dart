// ignore_for_file: prefer-static-class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';

import '../model/post.dart';

final postsCollection =
    FirebaseFirestore.instance.collection('posts').withConverter<Post>(
          fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data() ?? {}),
          toFirestore: (post, _) => post.toJson(),
        );

final postProvider =
    StreamProvider.autoDispose.family<DocumentSnapshot<Post>, String>(
  (ref, docId) {
    return postsCollection.doc(docId).snapshots();
  },
);

// Retrieves posts for a given topic.
final postsProvider = StreamProvider.autoDispose<QuerySnapshot<Post>>((ref) {
  final String? topic = ref.watch(selectedTopicProvider);
  if (topic == null) {
    // Get all posts if no topic selected.
    return postsCollection
        .orderBy('createdTime', descending: true)
        .limit(50)
        .snapshots();
  }

  return postsCollection
      .where('topic', isEqualTo: topic)
      .orderBy('createdTime', descending: true)
      .limit(50) // TODO: use pagination for posts.
      .snapshots();
});
