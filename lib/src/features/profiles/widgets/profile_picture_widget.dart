import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
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
    String cachingKey = 'profile-avatar-$userId';

    return FutureWrapper(
      // first check if the image is already cached
      future: getHiveCachedImage(
        cachingKey,
        imageOnCacheHitWithNoData:
            Image.asset(Images.placeholderProfilePicture).image,
      ),
      success: (imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        backgroundColor: Colors.transparent,
        radius: size,
      ),
      loading: ShimmerWidget(child: DefaultProfilePicture(radius: size)),
      onNoData: () => FutureWrapper(
        // if not, get the url for the image from Firebase Storage
        future: getProfilePictureUrl(userId),
        success: (url) => FutureWrapper(
          future: getHttpImageAndCache(
            // then download the image and cache it
            url!,
            key: cachingKey,
          ),
          success: (data) => CircleAvatar(
            backgroundImage: Image.memory(data!).image,
            backgroundColor: Colors.transparent,
            radius: size,
          ),
          loading: ShimmerWidget(child: DefaultProfilePicture(radius: size)),
          onNoData: () => DefaultProfilePicture(radius: size),
        ),
        loading: ShimmerWidget(child: DefaultProfilePicture(radius: size)),
        error: (_) => DefaultProfilePicture(radius: size),
        onNoData: () => setCacheEmptyForKeyAndReturnDefaultPicture(
          cachingKey,
        ),
      ),
      error: (_) => DefaultProfilePicture(radius: size),
    );
  }

  /// We tried to request the image from Firebase Storage, but the user has no profile picture.
  /// We set the cache to an empty image, so we don't have to try to download the image again.
  Widget setCacheEmptyForKeyAndReturnDefaultPicture(String key) {
    setEmptyImageCacheForKey(key);

    return DefaultProfilePicture(radius: size);
  }
}
