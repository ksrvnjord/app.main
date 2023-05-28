import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/comments_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentBottomBar extends StatelessWidget {
  final QueryDocumentSnapshot<Comment> snapshot;

  const CommentBottomBar({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double bottomBarFontSize = 14;
    final comment = snapshot.data();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    bool likedByMe = comment.likedBy.contains(uid);

    final colorScheme = Theme.of(context).colorScheme;

    const double opacity = 0.5;

    return [
      InkWell(
        child: Text(
          "Zwaan",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: likedByMe
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(opacity),
              ),
        ),
        onTap: () => CommentsService.like(snapshot),
      ),
      Text(timeago.format(
        comment.createdTime.toDate(),
        locale: 'nl_short',
      )).textColor(Colors.blueGrey).fontSize(bottomBarFontSize),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      separator: const SizedBox(width: 4),
    );
  }
}
