import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int contentMaxLines = 8;
    const double cardPadding = 8;
    const double authorNameFontSize = 14;

    return [
      Text(comment.authorName)
          .fontWeight(FontWeight.bold)
          .fontSize(authorNameFontSize),
      LimitedBox(
        maxWidth: MediaQuery.of(context).size.width,
        child: ExpandableText(
          comment.content,
          expandText: "meer",
          maxLines: contentMaxLines,
          linkColor: Colors.blueGrey,
          linkEllipsis: false,
          style: const TextStyle(
            fontSize: 16,
          ),
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
          color: Colors.lightBlue.shade50,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        );
  }
}
