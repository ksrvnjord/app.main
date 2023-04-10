import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  static const double cardPadding = 8;
  static const double profilePictureSize = 20;
  static const double authorNameFontSize = 12;
  static const double profilePicAndCommentSpacing = 4;

  @override
  Widget build(BuildContext context) {
    return [
      Text("Abra Ham").fontWeight(FontWeight.bold).fontSize(authorNameFontSize),
      Text(comment.content),
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
