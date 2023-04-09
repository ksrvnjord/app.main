import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_widget.dart';
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

  static const double commentsLeftPadding = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postDocId));
    final commentsVal = ref.watch(commentsProvider(postDocId));
    const double commentSpacing = 12;

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
          // shrinkWrap: true,
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
            commentsVal.when(
              data: (comments) => comments.size == 0
                  ? const Center(
                      child: Text('Er heeft nog niemand gereageerd'),
                    )
                  : comments.docs
                      .map((snapshot) => [
                            CommentWidget(snapshot: snapshot),
                            const SizedBox(height: commentSpacing),
                          ].toColumn())
                      .toList()
                      .toColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                      )
                      .padding(left: commentsLeftPadding),
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
