import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:provider/provider.dart';

class AlmanakProfileWidget extends StatelessWidget {
  final String profileId;

  const AlmanakProfileWidget({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    final user = almanakProfile(profileId, client);
    return Text(user.toString());
  }
}
