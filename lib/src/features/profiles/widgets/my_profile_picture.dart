import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_list_tile_widget.dart';

class MyProfilePicture extends ConsumerWidget {
  const MyProfilePicture({
    super.key,
    // ignore: no-magic-number
    this.profileIconSize = 48,
  });

  final double profileIconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(firebaseAuthUserProvider).value;

    return currentUser == null
        ? const SizedBox.shrink()
        : ProfilePictureListTileWidget(
            profileId: currentUser.uid,
            radius: profileIconSize,
          );
  }
}
