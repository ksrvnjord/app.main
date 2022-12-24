import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakUserButtonWidget extends StatelessWidget {
  final Query$Almanak$users$data user;

  const AlmanakUserButtonWidget(this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return Card(
      child: ListTile(
        leading: FutureBuilder(
            future: almanakProfile(user.id, client),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CircleAvatar(
                  backgroundImage:
                      Image.asset(Images.placeholderProfilePicture).image,
                );
              } else if (snapshot.hasData) {
                String userId = snapshot.data!.identifier;

                return FutureBuilder(
                    future: getProfilePicture(userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return CircleAvatar(
                          backgroundImage:
                              Image.asset(Images.placeholderProfilePicture)
                                  .image,
                        );
                      } else if (snapshot.hasData) {
                        MemoryImage image =
                            MemoryImage(snapshot.data as Uint8List);

                        return CircleAvatar(
                          backgroundImage: image,
                        );
                      }

                      return CircleAvatar(
                        backgroundImage:
                            Image.asset(Images.placeholderProfilePicture).image,
                      );
                    });
              } else {
                return CircleAvatar(
                  backgroundImage:
                      Image.asset(Images.placeholderProfilePicture).image,
                );
              }
            }),
        title: Text(
            '${user.fullContact.public.first_name ?? ''} ${user.fullContact.public.last_name ?? ''}'),
        onTap: () {
          Routemaster.of(context).push('/almanak/${user.id}');
        },
      ),
    );
  }
}
