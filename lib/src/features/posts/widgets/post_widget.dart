import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_bottom_action_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_header_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_statistics_bar.dart';
import 'package:styled_widget/styled_widget.dart';

class PostWidget extends ConsumerWidget {
  const PostWidget({
    super.key,
    required this.snapshot,
    this.expanded = false,
  });

  final DocumentSnapshot<Post> snapshot;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Post post = snapshot.data()!;
    const int contentMaxLines = 12;

    const double titleFontSize = 20;
    const double headerPadding = 4;
    const double postStatisticsTopPadding = 4;

    return [
      PostHeaderBar(snapshot: snapshot).padding(bottom: headerPadding),
      Text(
        post.title,
        overflow: TextOverflow.ellipsis,
      )
          .fontSize(titleFontSize)
          .fontWeight(FontWeight.bold)
          .alignment(Alignment.centerLeft),
      [
        Flexible(
          child: ExpandableText(
            post.content,
            expandText: "meer",
            maxLines: contentMaxLines,
            linkColor: Colors.blueGrey,
            linkEllipsis: false,
            expanded: expanded,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ].toRow(),
      PostStatisticsBar(snapshot: snapshot)
          .padding(top: postStatisticsTopPadding),
      const Divider(),
      PostBottomActionBar(
        snapshot: snapshot,
      ),
    ].toColumn();
  }
}
