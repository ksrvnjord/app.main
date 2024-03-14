import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/assets/svgs.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class PostStatisticsBar extends ConsumerWidget {
  const PostStatisticsBar({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final DocumentSnapshot<Post> snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = snapshot.data();
    final commentsVal = ref.watch(commentsProvider(snapshot.id));
    const swanIconSize = 16.0;

    final colorScheme = Theme.of(context).colorScheme;

    return [
      if (post != null && post.likedBy.isNotEmpty)
        GestureDetector(
          child: [
            Text(
              // ignore: avoid-non-ascii-symbols
              "${post.likedBy.length.toString()}x ",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: colorScheme.outline),
            ),
            SvgPicture.asset(
              Svgs.swanWhite,
              width: swanIconSize,
              // ignore: no-equal-arguments
              height: swanIconSize,
              // ignore: deprecated_member_use
              color: colorScheme.primary,
            ),
          ].toRow(),
          // ignore: prefer-extracting-callbacks
          onTap: () {
            // Ga naar aparte pagina.
            context.goNamed("Liked By", pathParameters: {'id': snapshot.id});
          },
        ),
      commentsVal.when(
        data: (data) => data.size > 0
            ? InkWell(
                child: Text(
                  "${data.size} reactie${data.size > 1 ? 's' : ''}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                onTap: () => context.goNamed(
                  RouteName.postComments,
                  pathParameters: {'id': snapshot.id},
                ),
              )
            : const SizedBox.shrink(),
        error: (error, stack) => Text(error.toString()),
        loading: () => const SizedBox.shrink(),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      separator: const SizedBox(
        width: 4,
      ),
    );
  }
}
