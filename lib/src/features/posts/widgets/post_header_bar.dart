import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';

class PostHeaderBar extends StatelessWidget {
  final Post post;

  const PostHeaderBar({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double profilePictureIconSize = 16;
    const double postTimeFontSize = 12;
    const double titleLeftPadding = 8;

    return [
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
    ].toRow();
  }
}
