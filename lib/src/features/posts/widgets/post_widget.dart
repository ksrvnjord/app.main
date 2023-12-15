import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_bottom_action_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_header_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_statistics_bar.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/firebasestorage_cached_image_provider.dart';
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
    final post = snapshot.data();
    const contentMaxLines = 12;

    const headerPadding = 4.0;
    const postStatisticsTopPadding = 4.0;

    bool darkMode = Theme.of(context).brightness == Brightness.dark;

    Map<String, Color> topicColors = {
      "Gevonden voorwerpen":
          darkMode ? Colors.green.shade900 : Colors.green.shade100,
      // ignore: prefer-moving-to-variable
      "Gezocht": darkMode ? Colors.orange.shade900 : Colors.orange.shade100,
      "Kaartjes": darkMode ? Colors.yellow.shade900 : Colors.yellow.shade100,
      "Promotie": darkMode ? Colors.red.shade900 : Colors.red.shade100,
      "Wandelgangen": darkMode ? Colors.blue.shade900 : Colors.blue.shade100,
    };
    final postTopic = post?.topic ?? "";

    final textTheme = Theme.of(context).textTheme;

    final postImageRef = post?.imageRef;

    return <Widget>[
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
      if (postImageRef != null)
        ref
            .watch(firebaseStorageCachedImageProvider(postImageRef.fullPath))
            .when(
              data: (image) => Image(
                image: image,
                semanticLabel: "Post Image",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              error: (error, stackTrace) => const Icon(Icons.error),
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
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
      PostBottomActionBar(snapshot: snapshot),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }
}
