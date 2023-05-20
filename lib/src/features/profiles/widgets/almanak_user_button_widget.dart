import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_list_tile_widget.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakUserButtonWidget extends ConsumerWidget {
  final Query$Almanak$users$data user;

  const AlmanakUserButtonWidget(this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicContact = user.fullContact.public;

    return Card(
      // Add rounding of 16.
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        // Add rounding to list tile.
        leading: ProfilePictureListTileWidget(profileId: user.identifier),
        title: Text(
          '${publicContact.first_name ?? ''} ${publicContact.last_name ?? ''}',
        ),
        onTap: () => Routemaster.of(context).push(
          FirebaseAuth.instance.currentUser != null
              ? user.identifier
              : user
                  .id, // Some demo users have no identifier and we don't query Firebase for them, so we use the id instead.
        ),
      ),
    );
  }
}
