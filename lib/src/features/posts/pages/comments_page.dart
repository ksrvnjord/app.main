import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comments_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class CommentsPage extends ConsumerWidget {
  const CommentsPage({
    Key? key,
    required this.docId,
  }) : super(key: key);

  final String docId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(docId));
    final comments = ref.watch(commentsProvider(docId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.lightBlue,
        ),
      ),
      body: ListView(
        children: [
          post.when(
            data: (data) => PostWidget(doc: data),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) =>
                ErrorCardWidget(errorMessage: error.toString()),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Divider(
              height: 0,
            ),
          ),
          comments.when(
            data: (data) => CommentsWidget(comments: data),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) =>
                ErrorCardWidget(errorMessage: error.toString()),
          ),
        ],
      ),
    );
  }
}
