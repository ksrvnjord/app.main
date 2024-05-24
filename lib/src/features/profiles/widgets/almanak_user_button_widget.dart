import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_list_tile_widget.dart';

class AlmanakUserButtonWidget extends ConsumerWidget {
  const AlmanakUserButtonWidget(this.user, {super.key, required this.onTap});

  final DjangoUser user;
  final void Function() onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading:
          ProfilePictureListTileWidget(profileId: user.identifier.toString()),
      title: Text(
        '${user.firstName} ${user.lastName}',
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
