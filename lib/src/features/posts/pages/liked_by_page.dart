import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/liked_by_users_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';

class LikedByPage extends ConsumerWidget {
  const LikedByPage({super.key, required this.snapshotId});

  final String snapshotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedByProvider = ref.watch(likedByUsersProvider(snapshotId));

    return Scaffold(
      appBar: AppBar(title: const Text("Jouw post is geliket door")),
      body: likedByProvider.when(
        data: (likedByUsers) {
          return likedByUsers.isEmpty
              ? const Center(child: Text("Nog niemand heeft deze post geliket"))
              : ListView(
                  children: likedByUsers
                      .map((user) => AlmanakUserTile(
                            firstName: user.firstName,
                            lastName: user.lastName,
                            lidnummer: user.identifier.toString(),
                          ))
                      .toList(),
                );
        },
        error: (error, stackTrace) {
          return Center(child: Text("Error: $error"));
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
