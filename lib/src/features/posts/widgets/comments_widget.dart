import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({
    Key? key,
    required this.comments,
  }) : super(key: key);

  final QuerySnapshot<Comment> comments;
  static const double commentSpacing = 12;

  @override
  Widget build(BuildContext context) {
    return comments.size == 0
        ? const Center(
            child: Text('Er heeft nog niemand gereageerd'),
          )
        : [
            ...comments.docs.map((snapshot) => [
                  CommentWidget(snapshot: snapshot),
                  const SizedBox(height: commentSpacing),
                ].toColumn()),
          ].toColumn();
  }
}
