import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
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
      child: ListTile(
        leading: FutureWrapper(
          future: getUserIdentifier(client, user.id),
          success: (snapshot) {
            String userId = snapshot!;
            
            return FutureWrapper(
              future: getProfilePictureUrl(userId), // TODO: use cache
              success: (snapshot) {
                return CachedNetworkImage(
                  imageUrl: // random image url
                      snapshot as String,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (_,x) => showDefaultProfilePicture(),
                );
                // return CircleAvatar(
                //   backgroundImage: MemoryImage(snapshot as Uint8List),
                // );
              },
              error: (_) => showDefaultProfilePicture(),
              loading: ShimmerWidget(child: showDefaultProfilePicture()),
            );
          },
          error: (_) => showDefaultProfilePicture(),
          loading: ShimmerWidget(child: showDefaultProfilePicture()),
        ),
        title: Text(
            '${user.fullContact.public.first_name ?? ''} ${user.fullContact.public.last_name ?? ''}'),
        onTap: () {
          Routemaster.of(context).push('/almanak/${user.id}');
        },
      ),
    );
  }
}

CircleAvatar showDefaultProfilePicture() {
  return CircleAvatar(
    backgroundImage: Image.asset(Images.placeholderProfilePicture).image,
  );
}
