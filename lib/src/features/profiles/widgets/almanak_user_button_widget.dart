import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_list_tile_widget.dart';

class AlmanakUserButtonWidget extends ConsumerWidget {
  final Query$Almanak$users$data user;
  final void Function()? onTap;

  const AlmanakUserButtonWidget(this.user, {Key? key, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicContact = user.fullContact.public;

    return ListTile(
      leading: ProfilePictureListTileWidget(profileId: user.identifier),
      title: Text(
        '${publicContact.first_name ?? ''} ${publicContact.last_name ?? ''}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.primary,
      ),
      visualDensity: VisualDensity.standard,
      onTap: onTap,
    );
  }
}
