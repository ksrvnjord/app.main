import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/author_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.postAuthor,
    required this.comment,
  });

  final Comment comment;
  final FirestoreUser? postAuthor;

  @override
  Widget build(BuildContext context) {
    const int contentMaxLines = 8;
    const double cardPadding = 8;
    const double authorNameFontSize = 14;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return [
      AuthorWidget(
        postAuthor: postAuthor,
        authorName: comment.authorName,
        fontSize: authorNameFontSize,
      ),
      LimitedBox(
        maxWidth: MediaQuery.of(context).size.width,
        child: ExpandableText(
          comment.content,
          expandText: "meer",
          linkColor: colorScheme.secondary,
          linkEllipsis: false,
          urlStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.secondary,
            decoration: TextDecoration.underline,
          ),
          onUrlTap: (url) => launchUrlString(url),
          style: textTheme.bodyLarge,
          maxLines: contentMaxLines,
        ),
      ),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        )
        .padding(all: cardPadding)
        .card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
        );
  }
}
