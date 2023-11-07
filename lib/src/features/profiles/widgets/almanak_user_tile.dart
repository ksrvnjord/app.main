import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_list_tile_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakUserTile extends ConsumerWidget {
  const AlmanakUserTile({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.subtitle,
    required this.lidnummer,
  }) : super(key: key);
  final String firstName;
  final String lastName;
  final String? subtitle;
  final String lidnummer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(lidnummer));

    const double titleShimmerHeight = 18;
    const double subtitleShimmerHeight = 12;
    const double titleShimmerPadding = 128;
    const double subtitleShimmerPadding = 64;

    return user.when(
      data: (u) => ListTile(
        leading: ProfilePictureListTileWidget(profileId: lidnummer),
        title: Text("$firstName $lastName"),
        subtitle: subtitle != null ? Text(subtitle as String) : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => context
            .pushNamed("Lid", pathParameters: {"id": u.identifier.toString()}),
      ),
      loading: () => ListTile(
        leading: const ShimmerWidget(child: DefaultProfilePicture()),
        title: ShimmerWidget(
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.grey[300],
              shape: const RoundedRectangleBorder(),
            ),
            height: titleShimmerHeight,
          ),
        ).padding(right: titleShimmerPadding),
        subtitle: subtitle == null
            ? null
            : ShimmerWidget(
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.grey[300],
                    shape: const RoundedRectangleBorder(),
                  ),
                  height: subtitleShimmerHeight,
                ),
              ).padding(right: subtitleShimmerPadding),
      ),
      error: (error, stackTrace) =>
          ErrorCardWidget(errorMessage: error.toString()),
    ); // Show nothing if no heimdall user is found.
  }
}
