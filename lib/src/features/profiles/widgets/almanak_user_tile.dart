import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/heimdall_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:routemaster/routemaster.dart';
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
    final heimdallAlmanakProfile =
        ref.watch(heimdallAlmanakProfileProvider(lidnummer));

    const double titleShimmerHeight = 18;
    const double subtitleShimmerHeight = 12;
    const double titleShimmerPadding = 128;
    const double subtitleShimmerPadding = 64;

    return heimdallAlmanakProfile.when(
      data: (user) => user == null
          ? const SizedBox() // no user found, show nothing
          : ListTile(
              leading: ProfilePictureWidget(userId: lidnummer),
              title: Text("$firstName $lastName"),
              subtitle: subtitle != null ? Text(subtitle!) : null,
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.lightBlue),
              onTap: () => Routemaster.of(context).push(user.identifier),
            ),
      loading: () => ListTile(
        leading: const ShimmerWidget(child: DefaultProfilePicture()),
        title: ShimmerWidget(
          child: Container(
            height: titleShimmerHeight,
            decoration: ShapeDecoration(
              shape: const RoundedRectangleBorder(),
              color: Colors.grey[300],
            ),
          ),
        ).padding(right: titleShimmerPadding),
        subtitle: subtitle == null
            ? null
            : ShimmerWidget(
                child: Container(
                  height: subtitleShimmerHeight,
                  decoration: ShapeDecoration(
                    shape: const RoundedRectangleBorder(),
                    color: Colors.grey[300],
                  ),
                ),
              ).padding(right: subtitleShimmerPadding),
      ),
      error: (error, stackTrace) =>
          ErrorCardWidget(errorMessage: error.toString()),
    ); // show nothing if no heimdall user is found
  }
}
