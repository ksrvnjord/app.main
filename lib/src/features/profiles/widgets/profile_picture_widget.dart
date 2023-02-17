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
    required this.size,
  }) : super(key: key);

  final String userId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: getProfilePicture(userId),
      success: (Uint8List? data) => CircleAvatar(
        radius: size,
        backgroundImage: MemoryImage(data!),
      ),
      error: (error) => CircleAvatar(
        radius: size,
        backgroundImage: const AssetImage(Images.placeholderProfilePicture),
      ),
      loading: ShimmerWidget(
        child: CircleAvatar(
          radius: size,
          backgroundImage: const AssetImage(Images.placeholderProfilePicture),
        ),
      ),
    );
  }
}
