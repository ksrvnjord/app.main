import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/clickable_profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostHeaderBar extends StatelessWidget {
  final DocumentSnapshot<Post> snapshot;

  const PostHeaderBar({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final post = snapshot.data()!;
    const double profilePictureIconSize = 16;
    const double postTimeFontSize = 12;
    const double titleLeftPadding = 8;

    void deletePost() {
      Navigator.of(context, rootNavigator: true).pop();
      PostService.deletePost(snapshot.reference.path);
    }

    return [
      [
        ClickableProfilePictureWidget(
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
      // three dots for more options, show if user is author

      if (post.authorId == FirebaseAuth.instance.currentUser!.uid)
        InkWell(
          onTap: () => showDialog(
            context: context,
            builder:
                // create dialog to delete post
                (context) => AlertDialog(
              title: const Text('Verwijderen'),
              content: const Text(
                'Weet je zeker dat je dit bericht wilt verwijderen?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuleren'),
                ),
                TextButton(
                  onPressed: deletePost,
                  child: const Text('Verwijderen').textColor(Colors.red),
                ),
              ],
            ),
          ),
          child: const Icon(Icons.delete_outlined),
        ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
