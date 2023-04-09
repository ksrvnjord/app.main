import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      ProfilePictureWidget(userId: comment.authorId, size: 20),
    ].toRow();
  }
}
