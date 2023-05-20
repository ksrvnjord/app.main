import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class ProfilePictureListTileWidget extends ConsumerWidget {
  const ProfilePictureListTileWidget({
    super.key,
    required this.profileId,
    this.radius,
  });

  final String profileId;
  final double? radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ImageProvider<Object>> profilePicture =
        ref.watch(profilePictureThumbnailProvider(profileId));

    return profilePicture.when(
      data: (data) => CircleAvatar(
        backgroundColor: Colors.grey[300]!,
        foregroundImage: data,
        radius: radius,
      ),
      loading: () => ShimmerWidget(
        child: CircleAvatar(
          radius: radius,
        ),
      ),
      error: (obj, stk) => CircleAvatar(
        foregroundColor: Colors.red,
        radius: radius,
      ),
    );
  }
}
