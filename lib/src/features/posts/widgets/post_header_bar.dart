import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/author_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/clickable_profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostHeaderBar extends ConsumerWidget {
  const PostHeaderBar({super.key, required this.snapshot});

  final DocumentSnapshot<Post> snapshot;

  void _deletePost(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pop();
    // ignore: avoid-ignoring-return-values
    await PostService.deletePost(snapshot);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = snapshot.data();
    const double profilePictureIconSize = 20;
    const double titleLeftPadding = 8;

    final postAuthorId = post?.authorId ?? "";

    // final postAuthor = ref.watch(firestoreUserProvider(postAuthorId));

    // final firebaseUser = ref.watch(currentFirestoreUserProvider);

    final postAuthor = ref.watch(userProvider(postAuthorId));

    final currentUser = ref.watch(currentUserNotifierProvider);

    return [
      [
        ClickableProfilePictureWidget(
          userId: postAuthorId,
          size: profilePictureIconSize,
        ),
        [
          AuthorWidget(
            postAuthor: postAuthor.when(
              data: (user) => user,
              loading: () => null,
              error: (error, _) {
                FirebaseCrashlytics.instance.recordError(
                  error,
                  StackTrace.current,
                );
                return null;
              },
            ),
            authorName: post?.authorName ?? "Onbekend",
          ),
          Text(
            timeago.format(
              post?.createdTime.toDate() ?? DateTime.now(),
              locale: 'nl',
            ),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ]
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .padding(left: titleLeftPadding),
      ].toRow(),
      // Three dots for more options, show if user is author.

      if (currentUser != null &&
          (postAuthorId == currentUser.identifier.toString() ||
              currentUser.isBestuur))
        InkWell(
          child: const Icon(Icons.delete_outlined),
          // ignore: avoid-async-call-in-sync-function
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
                  // ignore: prefer-correct-handler-name
                  onPressed: () => _deletePost(context),
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
