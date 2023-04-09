import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
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
  static const int contentMaxLines = 3;

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
      [
        Text(
          post.content,
          maxLines: contentMaxLines,
          overflow: TextOverflow.ellipsis,
        ).expanded(),
      ].toRow(),
      // [].toRow(mainAxisAlignment: MainAxisAlignment.end),

      [
        Text(
          "${post.likedBy.length.toString()} likes",
        ).textColor(Colors.blueGrey),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      const Divider(),
      [
        DisplayLikes(
          docRef: doc.reference,
          likedBy: post.likedBy,
          iconSize: likeIconSize,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.end),
    ].toColumn().padding(horizontal: 16, top: 16).card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        );
  }
}
