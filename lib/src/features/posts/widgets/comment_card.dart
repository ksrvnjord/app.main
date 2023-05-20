import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/author_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final FirebaseUser? postAuthor;

  const CommentCard({Key? key, required this.postAuthor, required this.comment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int contentMaxLines = 8;
    const double cardPadding = 8;
    const double authorNameFontSize = 14;

    return [
      AuthorWidget(
          postAuthor: postAuthor,
          authorName: comment.authorName,
          fontSize: authorNameFontSize),
      LimitedBox(
        maxWidth: MediaQuery.of(context).size.width,
        child: ExpandableText(comment.content,
            expandText: "meer",
            linkColor: Colors.blueGrey,
            linkEllipsis: false,
            urlStyle: const TextStyle(color: Colors.blue),
            onUrlTap: (url) => launchUrlString(url),
            style: const TextStyle(fontSize: 16),
            maxLines: contentMaxLines),
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
          color: Colors.lightBlue.shade50,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        );
  }
}
