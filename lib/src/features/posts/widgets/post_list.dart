import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_card.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const docsPerQuery = 5;

    final selectedTopic = ref.watch(selectedTopicProvider);

    final query = ref.watch(postQueryProvider(selectedTopic));

    return FirestorePagination<Post>(
      query: query,
      itemBuilder: (context, snapshot, index) => PostCard(
        snapshot: snapshot,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      limit: docsPerQuery,
      isLive: true,
      padding: const EdgeInsets.only(bottom: 80),
    );
  }
}
