import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  static const double cardPadding = 8;
  static const double profilePictureSize = 20;
  static const double authorNameFontSize = 12;
  static const double profilePicAndCommentSpacing = 4;

  @override
  Widget build(BuildContext context) {
    return [
      ProfilePictureWidget(userId: comment.authorId, size: profilePictureSize),
      [
        [
          Text(comment.authorName)
              .fontWeight(FontWeight.bold)
              .fontSize(authorNameFontSize),
          Text(comment.content),
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .padding(all: cardPadding)
            .card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: Colors.lightBlue.shade50,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
        [
          Text(timeago.format(comment.createdTime.toDate(), locale: 'nl_short'))
              .textColor(Colors.blueGrey)
              .fontSize(authorNameFontSize),
        ].toRow().padding(left: cardPadding),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .padding(left: profilePicAndCommentSpacing),
    ].toRow(crossAxisAlignment: CrossAxisAlignment.start);
  }
}
