import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/amount_of_likes_for_comment_widget.dart';
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
      [
        ProfilePictureWidget(
            userId: comment.authorId, size: profilePictureSize),
        Flexible(child: Text(comment.content)),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(width: profilePicAndCommentSpacing),
      ),
      // create positioned red circle
      Positioned(
        right: 0,
        bottom: 0,
        child: AmountOfLikesForCommentWidget(
          amountOfLikes: comment.likedBy.length,
        ),
      ),
    ].toStack();
  }
}
