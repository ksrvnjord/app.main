import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_list_tile_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

class MyProfilePicture extends ConsumerWidget {
  const MyProfilePicture({
    super.key,
    // ignore: no-magic-number
    this.profileIconSize = 48,
  });

  final double profileIconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(firebaseAuthUserProvider);

    return ProfilePictureListTileWidget(
      profileId: currentUser!.uid,
      radius: profileIconSize,
    );
  }
}
