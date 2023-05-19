import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(newPostsProvider);

    return ListView(padding: const EdgeInsets.only(bottom: 64), children: [
      posts.when(
        data: (snapshot) => snapshot.size == 0
            ? const Center(
                child: Text("Wees de eerste die een post plaatst!"),
              )
            : [
                for (final doc in snapshot.docs) ...[
                  PostCard(
                    snapshot: doc,
                    elevation: false,
                    squareBorder: true,
                  ),
                  const SizedBox(height: 8),
                ],
              ].toColumn(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => ErrorCardWidget(
          errorMessage: error.toString(),
        ),
      ),
    ]);
  }
}
