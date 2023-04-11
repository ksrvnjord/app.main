import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:tuple/tuple.dart';

class ProfilePictureListTileWidget extends ConsumerWidget {
  const ProfilePictureListTileWidget({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ImageProvider<Object>> profilePicture = ref.watch(
      profilePictureProvider(Tuple2(profileId, true)),
    ); // get thumbnail

    return profilePicture.when(
      data: (data) => CircleAvatar(
        foregroundImage: data,
        backgroundColor: Colors.grey[300]!,
      ),
      loading: () => const ShimmerWidget(child: CircleAvatar()),
      error: (obj, stk) => const CircleAvatar(
        foregroundColor: Colors.red,
      ),
    );
  }
}
