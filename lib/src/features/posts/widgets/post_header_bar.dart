import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/author_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/clickable_profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostHeaderBar extends ConsumerWidget {
  final DocumentSnapshot<Post> snapshot;

  const PostHeaderBar({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = snapshot.data()!;
    const double profilePictureIconSize = 20;
    const double postTimeFontSize = 14;
    const double titleLeftPadding = 8;

    final postAuthor = ref.watch(firestoreUserProvider(post.authorId));

    final firebaseUser = ref.watch(currentFirebaseUserProvider);

    void deletePost() async {
      Navigator.of(context, rootNavigator: true).pop();
      // ignore: avoid-ignoring-return-values
      await PostService.deletePost(snapshot.reference.path);
    }

    return [
      [
        ClickableProfilePictureWidget(
          userId: post.authorId,
          size: profilePictureIconSize,
        ),
        [
          AuthorWidget(postAuthor: postAuthor, authorName: post.authorName),
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

      if (firebaseUser != null &&
          (post.authorId == firebaseUser.uid || firebaseUser.isBestuur))
        InkWell(
          child: const Icon(Icons.delete_outlined),
          onTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
        ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
