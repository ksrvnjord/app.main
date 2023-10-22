import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_card.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const docsPerQuery = 5;

    return FirestorePagination(
      query: FirebaseFirestore.instance
          .collection('posts')
          .withConverter<Post>(
            fromFirestore: (snapshot, _) =>
                Post.fromJson(snapshot.data() ?? {}),
            toFirestore: (post, _) => post.toJson(),
          )
          .orderBy('createdTime', descending: true),
      itemBuilder: (context, snap, index) {
        final postSnapshot = snap as DocumentSnapshot<Post>;

        return PostCard(
          snapshot: postSnapshot,
          elevation: false,
          squareBorder: true,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      limit: docsPerQuery,
      isLive: true,
      padding: const EdgeInsets.only(bottom: 80),
    );
  }
}
