import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/display_likes.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.doc,
  });

  final DocumentSnapshot<Post> doc;

  static const likeIconSize = 20.0;
  static const double profilePictureIconSize = 16;
  static const double postTimeFontSize = 12;
  static const double titleLeftPadding = 8;
  static const int contentMaxLines = 3;
  static const double postPadding = 8;

  @override
  Widget build(BuildContext context) {
    final Post post = doc.data()!;

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
      Text(
        post.title,
        overflow: TextOverflow.ellipsis,
      )
          .fontSize(16)
          .fontWeight(FontWeight.bold)
          .alignment(Alignment.centerLeft),
      [
        Expanded(
          child: ExpandableText(
            post.content,
            expandText: "meer",
            collapseText: "minder",
            maxLines: contentMaxLines,
            linkColor: Colors.blueGrey,
            linkEllipsis: false,
          ),
        ),
      ].toRow(),
      [
        Text(
          "${post.likedBy.length.toString()}x 'Vo amice",
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
        InkWell(
          onTap: () => Routemaster.of(context).push('${doc.id}/comments'),
          child: [
            const Icon(
              Icons.mode_comment_outlined,
              size: 20,
            ),
            const Text("Commenteren").padding(left: 4),
          ].toRow(),
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround),
    ].toColumn().padding(all: postPadding).card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        );
  }
}
