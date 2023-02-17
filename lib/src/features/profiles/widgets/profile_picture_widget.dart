import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
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
      future: getProfilePictureUrl(userId), // TODO: use cache
      success: (snapshot) => CachedNetworkImage(
        imageUrl: // random image url
            snapshot,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size,
          backgroundImage: imageProvider,
        ),
        placeholder: (_, x) => DefaultProfilePicture(radius: size),
      ),
      error: (_) => DefaultProfilePicture(radius: size),
      loading: ShimmerWidget(child: DefaultProfilePicture(radius: size)),
    );
  }
}
