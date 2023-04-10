import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key, required this.topic}) : super(key: key);

  final String topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider(topic));

    return posts.when(
      data: (snapshot) => snapshot.size == 0
          ? const Center(
              child: Text("Er zijn nog geen berichten geplaatst."),
            )
          : ListView.separated(
              itemCount: snapshot.size,
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 64),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: ((context, index) =>
                  PostCard(snapshot: snapshot.docs[index])),
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
