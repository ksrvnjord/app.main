import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/create_comment_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_card.dart';
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
    final commentsVal = ref.watch(commentsProvider(postDocId));
    const double commentSpacing = 12;
    const double commentHPadding = 8;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                data: (data) => PostCard(
                  snapshot: data,
                  elevation: false,
                  squareBorder: true,
                  expandContent: true,
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) =>
                    ErrorCardWidget(errorMessage: error.toString()),
              ),
              const SizedBox(height: 8),
              commentsVal.when(
                data: (data) => data.size == 0
                    ? const Center(
                        child: Text('Er heeft nog niemand gereageerd'),
                      )
                    : data.docs
                        .map(
                          (e) => Align(
                            alignment: Alignment.centerLeft,
                            child: CommentWidget(snapshot: e),
                          ),
                        )
                        .toList()
                        .toColumn(
                          separator: const SizedBox(height: commentSpacing),
                        )
                        .padding(horizontal: commentHPadding),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) =>
                    ErrorCardWidget(errorMessage: error.toString()),
              ),
              const SizedBox(height: 64),
            ],
          ).expanded(),
          CreateCommentWidget(postDocId: postDocId),
        ].toColumn(), // fill space between appbar and create comment widget
      ),
    );
  }
}
