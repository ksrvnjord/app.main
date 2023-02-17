import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 96;

    return FutureWrapper(
      future: getProfilePicture(userId),
      success: (Uint8List? data) => CircleAvatar(
        radius: profilePictureSize,
        backgroundImage: MemoryImage(data!),
      ),
      error: (error) => const CircleAvatar(
        radius: profilePictureSize,
        backgroundImage: AssetImage(Images.placeholderProfilePicture),
      ),
      loading: const ShimmerWidget(
        child: CircleAvatar(
          radius: profilePictureSize,
          backgroundImage: AssetImage(Images.placeholderProfilePicture),
        ),
      ),
    );
  }
}
