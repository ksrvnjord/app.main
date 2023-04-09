import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_bottom_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  static const double cardPadding = 8;
  static const double profilePictureSize = 20;

  static const double profilePicAndCommentSpacing = 4;

  @override
  Widget build(BuildContext context) {
    return [
      ProfilePictureWidget(userId: comment.authorId, size: profilePictureSize),
      [
        CommentCard(comment: comment),
        CommentBottomBar(comment: comment).padding(left: cardPadding),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .padding(left: profilePicAndCommentSpacing),
    ].toRow(crossAxisAlignment: CrossAxisAlignment.start);
  }
}

// // add amount of likes
// Positioned(
//   bottom: 0,
//   right: 0,
//   child: [
//     Text(comment.likedBy.length.toString())
//         .fontWeight(FontWeight.bold)
//         .fontSize(authorNameFontSize),
//   ].toRow(),
// ),


