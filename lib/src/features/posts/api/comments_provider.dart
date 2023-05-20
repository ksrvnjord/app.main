import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';

final commentsProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<Comment>, String>((ref, postId) {
  final commentsCollection = FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .withConverter<Comment>(
        fromFirestore: (snapshot, _) => Comment.fromMap(snapshot.data()!),
        toFirestore: (comment, _) => comment.toJson(),
      );

  return commentsCollection
      .orderBy('createdTime', descending: false) // Show oldest first.
      .snapshots();
});
