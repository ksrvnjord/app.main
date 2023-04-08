import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key, required this.topic}) : super(key: key);

  final String topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider(topic));

    return posts.when(
      data: (snapshot) => ListView.separated(
        itemCount: snapshot.size,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: ((context, index) =>
            PostWidget(doc: snapshot.docs[index])),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => ErrorCardWidget(
        errorMessage: error.toString(),
      ),
    );
  }
}
