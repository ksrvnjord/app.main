import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksrvnjord_main_app/assets/svgs.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:routemaster/routemaster.dart';
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
    const swanIconSize = 16.0;

    return [
      if (post.likedBy.isNotEmpty)
        [
          Text(
            // ignore: avoid-non-ascii-symbols
            "${post.likedBy.length.toString()}x ",
          ).textColor(Colors.blueGrey),
          SvgPicture.asset(
            Svgs.swanWhite,
            width: swanIconSize,
            // ignore: deprecated_member_use
            color: Colors.lightBlue,
            // ignore: no-equal-arguments
            height: swanIconSize,
          ),
        ].toRow(),
      commentsVal.when(
        data: (data) => data.size > 0
            ? InkWell(
                onTap: () =>
                    Routemaster.of(context).push('${snapshot.id}/comments'),
                child: Text(
                  "${data.size} reactie${data.size > 1 ? 's' : ''}",
                ).textColor(Colors.blueGrey),
              )
            : const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => Text(error.toString()),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      separator: const SizedBox(
        width: 4,
      ),
    );
  }
}
