import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_bottom_action_bar.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.snapshot,
  });

  final DocumentSnapshot<Post> snapshot;

  @override
  Widget build(BuildContext context) {
    final Post post = snapshot.data()!;

    const double profilePictureIconSize = 16;
    const double postTimeFontSize = 12;
    const double titleLeftPadding = 8;
    const int contentMaxLines = 3;
    const double postPadding = 8;

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
      PostBottomActionBar(
        snapshot: snapshot,
      ),
    ].toColumn().padding(all: postPadding).card(
          // TODO: abstract card out of here, so it can be used in other places
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        );
  }
}
