import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
// shared preferences

class AlmanakUserButtonWidget extends StatelessWidget {
  final Query$Almanak$users$data user;

  const AlmanakUserButtonWidget(this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return Card(
      // add rounding of 16
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        // add rounding to list tile
        leading: FutureWrapper(
          future: getUserIdentifier(client, user.id),
          success: showProfilePicture,
          error: (_) => const DefaultProfilePicture(),
          loading: const ShimmerWidget(child: DefaultProfilePicture()),
        ),
        title: Text(
          '${user.fullContact.public.first_name ?? ''} ${user.fullContact.public.last_name ?? ''}',
        ),
        onTap: () => Routemaster.of(context).push('/almanak/${user.id}'),
      ),
    );
  }

  Widget showProfilePicture(snapshot) {
    return FutureWrapper(
      future: getProfilePictureUrl(snapshot!), // TODO: use cache
      success: (snapshot) => CachedNetworkImage(
        imageUrl: // random image url
            snapshot,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
        ),
        placeholder: (_, x) => const DefaultProfilePicture(),
      ),
      error: (_) => const DefaultProfilePicture(),
      loading: const ShimmerWidget(child: DefaultProfilePicture()),
    );
  }
}
