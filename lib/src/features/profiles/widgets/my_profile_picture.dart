import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class MyProfilePicture extends StatelessWidget {
  const MyProfilePicture({
    super.key,
    required this.profileIconSize,
  });

  final double profileIconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: profileIconSize,
      icon: FutureWrapper(
        future: getMyProfilePicture(),
        success: (data) => data != null
            ? CircleAvatar(
                backgroundImage: MemoryImage(data),
              )
            : const DefaultProfilePicture(),
        loading: const ShimmerWidget(child: DefaultProfilePicture()),
        error: (_) => const DefaultProfilePicture(),
      ),
      onPressed: () => Routemaster.of(context).push('edit'),
    );
  }
}
