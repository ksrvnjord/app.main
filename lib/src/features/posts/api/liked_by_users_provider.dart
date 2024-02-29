import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';

// ignore: prefer-static-class
final likedByUsersProvider = FutureProvider.autoDispose
    .family<List<User>, String>((ref, snapshotId) async {
  final post = await ref.watch(postProvider(snapshotId).future);

  final likedBy = post.data()?.likedBy ?? [];

  final users = <User>[];

  for (final identifier in likedBy) {
    final snapshot =
        await ref.watch(firestoreUserStreamProvider(identifier).future);
    if (snapshot.size == 0) {
      continue;
    }

    // ignore: prefer-correct-identifier-length
    final u = await ref.watch(userProvider(identifier).future);
    users.add(u);
  }

  return users;
});
