import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/amount_of_likes_for_comment_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_bottom_bar.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_card.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Comment> snapshot;

  const CommentWidget({Key? key, required this.snapshot}) : super(key: key);

  static const double cardPadding = 8;
  static const double profilePictureSize = 20;

  static const double profilePicAndCommentSpacing = 4;

  @override
  Widget build(BuildContext context) {
    final comment = snapshot.data();

    const double authorNameFontSize = 12;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    bool likedByMe = comment.likedBy.contains(uid);
    final docRef = snapshot.reference;

    return [
      ProfilePictureWidget(
        userId: comment.authorId,
        size: profilePictureSize,
      ),
      Flexible(
        child: [
          [
            CommentCard(comment: comment),
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
            clipBehavior: Clip.none,
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
      separator: const SizedBox(width: profilePicAndCommentSpacing),
    );
  }
}
