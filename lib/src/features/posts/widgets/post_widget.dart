import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_list.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/display_likes.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.doc,
  });

  final QueryDocumentSnapshot<Post> doc;

  static const likeIconSize = 20.0;
  static const double profilePictureIconSize = 16;
  static const double postTimeFontSize = 12;
  static const double titleLeftPadding = 8;

  @override
  Widget build(BuildContext context) {
    final Post post = doc.data();

    return [
      [
        ProfilePictureWidget(
          userId: post.authorId,
          size: profilePictureIconSize,
        ),
        [
          Text(post.authorName),
          Text(timeago.format(post.createdTime.toDate(), locale: 'nl'))
              .textColor(Colors.blueGrey)
              .fontSize(postTimeFontSize),
        ]
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .padding(left: titleLeftPadding),
      ].toRow(),
      Text(post.title)
          .fontSize(16)
          .fontWeight(FontWeight.bold)
          .alignment(Alignment.centerLeft),
      // TODO: here the post's content
      // TODO: here a row with the post's likes and button to expand comments
      [
        const Spacer(),
        DisplayLikes(
          docRef: doc.reference,
          likedBy: post.likedBy,
          iconSize: likeIconSize,
        ),
      ].toRow(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      Text(post.content),
      const Divider(),
      ExpandChild(child: CommentList(post: doc)),
    ].toColumn().padding(all: 16).card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        );
  }
}
