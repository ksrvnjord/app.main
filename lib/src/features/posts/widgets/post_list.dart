import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_card.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopic = ref.watch(selectedTopicProvider);

    final postsVal = ref.watch(postsProvider(selectedTopic));

    return postsVal.when(
      data: (posts) {
        return posts.docs.isEmpty
            ? const Center(child: Text('No posts'))
            : ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  Image.asset('assets/images/sponsors/bohemian_birds.png'),
                  for (final post in posts.docs) PostCard(snapshot: post),
                ],
              );
      },
      error: (error, _) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
