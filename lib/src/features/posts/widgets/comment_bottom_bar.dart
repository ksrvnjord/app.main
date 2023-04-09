import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentBottomBar extends StatelessWidget {
  final QueryDocumentSnapshot<Comment> snapshot;

  const CommentBottomBar({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double authorNameFontSize = 12;
    final comment = snapshot.data();

    return [
      // TODO: add like text
      Text(timeago.format(comment.createdTime.toDate(), locale: 'nl_short'))
          .textColor(Colors.blueGrey)
          .fontSize(authorNameFontSize),
    ].toRow();
  }
}
