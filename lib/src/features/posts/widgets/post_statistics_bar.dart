import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:styled_widget/styled_widget.dart';

class PostStatisticsBar extends ConsumerWidget {
  const PostStatisticsBar({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final DocumentSnapshot<Post> snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Post post = snapshot.data()!;
    final commentsVal = ref.watch(commentsProvider(snapshot.id));

    return [
      Text(
        "${post.likedBy.length.toString()}x 'Vo amice",
      ).textColor(Colors.blueGrey),
      commentsVal.when(
        data: (data) => data.size > 0
            ? Text(
                "${data.size} reactie${data.size > 1 ? 's' : ''}",
              ).textColor(Colors.blueGrey)
            : const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => Text(error.toString()),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.start,
      separator: const SizedBox(
        width: 4,
      ),
    );
  }
}
