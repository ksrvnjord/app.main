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
      ProfilePictureWidget(userId: comment.authorId, size: 20).padding(top: 4),
      [
        [
          Text(comment.authorName).fontWeight(FontWeight.bold).fontSize(12),
          Text(comment.content),
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .padding(all: 8)
            .card(
              elevation: 0,
              color: Colors.lightBlue.shade50,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
        const Text("'Vo amice")
            .fontWeight(FontWeight.bold)
            .fontSize(12)
            .padding(horizontal: 8),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ].toRow(crossAxisAlignment: CrossAxisAlignment.start);
  }
}
