import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    Key? key,
    required this.userId,
    this.size,
  }) : super(key: key);

  final String userId;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: getProfilePictureUrl(userId),
      success: (snapshot) => snapshot != null
          ? FutureWrapper(
              future: cachedHttpImage(snapshot, key: 'profile-avatar-$userId'),
              success: (data) => data != null
                  ? CircleAvatar(
                      backgroundImage: Image.memory(data).image,
                      backgroundColor: Colors.transparent,
                      radius: size,
                    )
                  : DefaultProfilePicture(radius: size),
              loading:
                  ShimmerWidget(child: DefaultProfilePicture(radius: size)),
              error: (_) => DefaultProfilePicture(radius: size),
            )
          : DefaultProfilePicture(radius: size),
      error: (_) => DefaultProfilePicture(radius: size),
      loading: ShimmerWidget(child: DefaultProfilePicture(radius: size)),
    );
  }
}
