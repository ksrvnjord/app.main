import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_bottom_action_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_header_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_statistics_bar.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    final Post? post = snapshot.data();
    const int contentMaxLines = 12;

    const double headerPadding = 4;
    const double postStatisticsTopPadding = 4;

    bool darkMode = Theme.of(context).brightness == Brightness.dark;

    Map<String, Color> topicColors = {
      "Promotie": darkMode ? Colors.red.shade900 : Colors.red.shade100,
      "Wandelgangen": darkMode ? Colors.blue.shade900 : Colors.blue.shade100,
      "Kaartjes": darkMode ? Colors.yellow.shade900 : Colors.yellow.shade100,
      // ignore: prefer-moving-to-variable
      "Gezocht": darkMode ? Colors.orange.shade900 : Colors.orange.shade100,
      "Gevonden voorwerpen":
          darkMode ? Colors.green.shade900 : Colors.green.shade100,
    };
    final postTopic = post?.topic ?? "";

    final textTheme = Theme.of(context).textTheme;

    return [
      PostHeaderBar(snapshot: snapshot).padding(bottom: headerPadding),
      Text(
        post?.title ?? "",
        style: textTheme.titleLarge,
        overflow: TextOverflow.ellipsis,
      ).alignment(Alignment.centerLeft),
      [
        Flexible(
          child: ExpandableText(
            post?.content ?? "",
            expandText: "meer",
            expanded: expanded,
            linkColor: Colors.blueGrey,
            linkEllipsis: false,
            urlStyle: const TextStyle(color: Colors.blue),
            onUrlTap: (url) => launchUrlString(url),
            style: textTheme.bodyLarge,
            maxLines: contentMaxLines,
          ),
        ),
      ].toRow(),
      Image(image: image)
      Chip(
        label: Text(postTopic),
        side: BorderSide.none,
        backgroundColor: topicColors[postTopic] ??
            Theme.of(context).colorScheme.secondaryContainer,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      PostStatisticsBar(snapshot: snapshot)
          .padding(top: postStatisticsTopPadding),
      const Divider(),
      PostBottomActionBar(
        snapshot: snapshot,
      ),
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
