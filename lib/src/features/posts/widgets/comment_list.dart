import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/add_comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/display_likes.dart';

class CommentList extends ConsumerWidget {
  final QueryDocumentSnapshot<Object?> post;
  const CommentList({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsyncVal = ref.watch(commentsProvider(post.id));

    return commentsAsyncVal.when(
      data: (comments) => Column(
        children: [
          AddComment(
            post: post,
          ),
          SizedBox(
            height: 180,
            child: comments.size == 0
                ? const Center(child: Text('Er heeft nog niemand gereageerd'))
                : ListView.builder(
                    itemCount: comments.size,
                    itemBuilder: ((context, index) {
                      final doc = comments.docs[index];
                      final comment = doc.data();

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(0),
                        color: index.isEven
                            ? Colors.grey.shade100
                            : Colors.grey.shade50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                comment.authorName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              DisplayLikes(
                                docRef: doc.reference,
                                likedBy: comment.likedBy,
                                iconSize: 12,
                              ),
                            ]),
                            Text(
                              comment.content,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text(error.toString()),
    );
  }
}
