import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/zoomable_image.dart';
import 'package:tuple/tuple.dart';

/// Zoomable profile picture widget
class ProfilePictureWidget extends ConsumerWidget {
  const ProfilePictureWidget({
    Key? key,
    required this.userId,
    required this.size,
    this.zoomable = true,
    this.useThumbnail = false,
  }) : super(key: key);

  final String userId;
  final double size;
  final bool zoomable;
  final bool useThumbnail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ImageProvider<Object>> profilePicture =
        ref.watch(profilePictureProvider(Tuple2(
      userId,
      useThumbnail,
    )));

    return profilePicture.when(
      // first check if the image is already cached
      data: (imageProvider) => zoomable
          ? ZoomableImage(
              imageProvider: imageProvider,
              image: CircleAvatar(
                foregroundImage: imageProvider,
                backgroundColor: Colors.grey[300]!,
                radius: size,
              ),
            )
          : CircleAvatar(
              foregroundImage: imageProvider,
              backgroundColor: Colors.grey[300]!,
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
