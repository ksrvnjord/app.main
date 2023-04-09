import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comments_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/create_comment_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentsPage extends ConsumerWidget {
  const CommentsPage({
    Key? key,
    required this.postDocId,
  }) : super(key: key);

  final String postDocId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postDocId));
    final comments = ref.watch(commentsProvider(postDocId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.lightBlue,
        ),
      ),
      body: [
        ListView(
          children: [
            post.when(
              data: (data) => PostWidget(doc: data),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) =>
                  ErrorCardWidget(errorMessage: error.toString()),
            ),
            const SizedBox(height: 8),
            comments.when(
              data: (data) => CommentsWidget(comments: data),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) =>
                  ErrorCardWidget(errorMessage: error.toString()),
            ),
          ],
        ).expanded(),
        CreateCommentWidget(postDocId: postDocId),
      ].toColumn(),
    );
  }
}
