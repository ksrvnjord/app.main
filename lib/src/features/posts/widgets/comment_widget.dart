import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/amount_of_likes_for_comment_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_bottom_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Comment> snapshot;

  const CommentWidget({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comment = snapshot.data();

    const double cardPadding = 8;
    const double profilePictureSize = 20;

    const double profilePicAndCommentSpacing = 4;

    void deleteCommentAndPop() {
      Navigator.of(context, rootNavigator: true).pop(); // pop the context menu

      // delay delete, because otherwise the context menu will not be able to pop
      Future.delayed(
        const Duration(milliseconds: 1726 ~/ 2),
        () => CommentsService.deleteComment(
          snapshot.reference.path,
        ),
      );
    }

    return [
      ProfilePictureWidget(
        userId: comment.authorId,
        size: profilePictureSize,
      ),
      Flexible(
        // so that the comment can be as long as it wants
        child: [
          [
            CupertinoContextMenu(
              actions: [
                CupertinoContextMenuAction(
                  isDestructiveAction: true,
                  onPressed: deleteCommentAndPop,
                  trailingIcon: Icons.delete,
                  child: const Text('Verwijder'),
                ),
              ],
              child: SingleChildScrollView(
                // we need to wrap the comment card in a scroll view because of a small issue with the ContextMenu: https://github.com/flutter/flutter/issues/58880#issuecomment-886175435
                child: CommentCard(comment: comment),
              ),
            ),
            // create positioned red circle
            if (comment.likedBy.isNotEmpty)
              Positioned(
                right: -4,
                bottom: -6,
                child: AmountOfLikesForCommentWidget(
                  amountOfLikes: comment.likedBy.length,
                ),
              ),
          ].toStack(
            clipBehavior: Clip
                .none, // because of the amount of likes that clips outside the comment card
          ),
          CommentBottomBar(snapshot: snapshot).padding(left: cardPadding),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      separator: const SizedBox(width: profilePicAndCommentSpacing),
    );
  }
}
