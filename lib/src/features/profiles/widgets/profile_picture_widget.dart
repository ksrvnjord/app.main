import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class ProfilePictureWidget extends ConsumerWidget {
  const ProfilePictureWidget({
    Key? key,
    required this.userId,
    this.size,
  }) : super(key: key);

  final String userId;
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Uint8List?> profilePicture =
        ref.watch(profilePictureProvider(userId));

    return profilePicture.when(
      // first check if the image is already cached
      data: (data) => data == null
          ? DefaultProfilePicture(radius: size)
          : CircleAvatar(
              foregroundImage: Image.memory(data).image,
              backgroundImage:
                  Image.asset(Images.placeholderProfilePicture).image,
              backgroundColor: Colors.transparent,
              radius: size,
            ),
      loading: () => ShimmerWidget(child: DefaultProfilePicture(radius: size)),
      error: (obj, stk) => CircleAvatar(
        foregroundColor: Colors.red,
        radius: size,
      ),
    );
  }
}
