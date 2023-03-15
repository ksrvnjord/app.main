import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakUserButtonWidget extends ConsumerWidget {
  final Query$Almanak$users$data user;

  const AlmanakUserButtonWidget(this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      // add rounding of 16
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        // add rounding to list tile
        leading: ProfilePictureWidget(userId: user.identifier),
        title: Text(
          '${user.fullContact.public.first_name ?? ''} ${user.fullContact.public.last_name ?? ''}',
        ),
        onTap: () => Routemaster.of(context).push(user.id),
      ),
    );
  }
}
