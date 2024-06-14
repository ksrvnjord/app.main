import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/zoomable_image.dart';

/// Zoomable profile picture widget.
class ProfilePictureWidget extends ConsumerWidget {
  const ProfilePictureWidget({
    super.key,
    required this.userId,
    required this.size,
    this.zoomable = true,
    this.thumbnail = false,
  });

  final String userId;
  final double size;
  final bool zoomable;
  final bool thumbnail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ImageProvider<Object>> profilePicture = ref.watch(thumbnail
        ? profilePictureThumbnailProvider(userId)
        : profilePictureProvider(userId));

    final backgroundColor = Colors.grey.shade300;

    return profilePicture.when(
      // First check if the image is already cached.
      data: (imageProvider) => zoomable
          ? ZoomableImage(
              imageProvider: imageProvider,
              image: CircleAvatar(
                backgroundColor: backgroundColor,
                foregroundImage: imageProvider,
                radius: size,
              ),
            )
          : CircleAvatar(
              backgroundColor: backgroundColor,
              foregroundImage: imageProvider,
              radius: size,
            ),
      loading: () => ShimmerWidget(child: CircleAvatar(radius: size)),
      error: (obj, stk) => CircleAvatar(
        foregroundColor: Colors.red,
        radius: size,
      ),
    );
  }
}
