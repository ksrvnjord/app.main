import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_bottom_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Comment> snapshot;

  const CommentWidget({Key? key, required this.snapshot}) : super(key: key);

  static const double cardPadding = 8;
  static const double profilePictureSize = 20;

  static const double profilePicAndCommentSpacing = 4;

  @override
  Widget build(BuildContext context) {
    final comment = snapshot.data();

    return [
      ProfilePictureWidget(userId: comment.authorId, size: profilePictureSize),
      [
        [
          CommentCard(comment: comment),
          CommentBottomBar(snapshot: snapshot).padding(left: cardPadding),
        ]
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .padding(left: profilePicAndCommentSpacing),
        if (comment.likedBy.isNotEmpty)
          Positioned(
            bottom: 6,
            right: 0,
            child: Container(
              // make edges round
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                color: Colors.lightBlue.shade300,
              ),
              child: [
                // heart icon
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 12,
                ).padding(right: 2),
                Text(comment.likedBy.length.toString())
                    .fontWeight(FontWeight.bold)
                    .fontSize(12)
                    .textColor(Colors.white),
              ].toRow().padding(horizontal: 2),
            ),
          ),
      ].toStack(),
    ].toRow(crossAxisAlignment: CrossAxisAlignment.start);
  }
}
