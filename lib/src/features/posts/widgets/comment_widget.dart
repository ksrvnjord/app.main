import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/amount_of_likes_for_comment_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/clickable_profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_bottom_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_card.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Comment> snapshot;

  const CommentWidget({Key? key, required this.snapshot}) : super(key: key);

  // wrapper function for usage in the CupertinoContextMenu
  void popAnd(
    BuildContext context, {
    required Function onPop,
    bool waitForPopAnimation = false,
  }) {
    Navigator.of(context, rootNavigator: true).pop(); // pop the context menu

    if (waitForPopAnimation) {
      Future.delayed(
        const Duration(milliseconds: 1726 ~/ 2),
        () => onPop.call(),
      );
    } else {
      // delay delete, because otherwise the context menu will not be able to pop
      onPop.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final comment = snapshot.data();

    const double cardPadding = 8;
    const double profilePictureSize = 20;
    const double profilePicAndCommentSpacing = 4;
    final bool likedByMe = comment.likedByMe;

    return [
      ClickableProfilePictureWidget(
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
                  onPressed: () => popAnd(
                    context,
                    onPop: () => CommentsService.like(snapshot),
                  ),
                  trailingIcon: likedByMe ? Icons.heart_broken : Icons.favorite,
                  child: Text(likedByMe ? "Anti-Zwaan" : "Zwaan"),
                ),

                // only show delete button if the comment is from the current user
                if (FirebaseAuth.instance.currentUser!.uid == comment.authorId)
                  CupertinoContextMenuAction(
                    isDestructiveAction: true,
                    onPressed: () => popAnd(
                      context,
                      onPop: () => CommentsService.deleteComment(
                        snapshot.reference.path,
                      ),
                      waitForPopAnimation: true,
                    ),
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
                // these values are hardcoded because they are based on the design
                // ignore: no-magic-number
                right: -4,
                // ignore: no-magic-number
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
