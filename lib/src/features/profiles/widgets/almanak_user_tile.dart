import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakUserTile extends StatelessWidget {
  const AlmanakUserTile({
    super.key,
    required this.firstName,
    required this.lastName,
    this.subtitle,
    required this.lidnummer,
  });
  final String firstName;
  final String lastName;
  final String? subtitle;
  final String lidnummer;

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return FutureWrapper(
      future: almanakProfileByIdentifier(lidnummer, client),
      success: (heimdallUser) => ListTile(
        leading: ProfilePictureWidget(userId: lidnummer),
        title: Text("$firstName $lastName"),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        onTap: () => Routemaster.of(context).push(heimdallUser!.id),
      ),
      loading:
          ShimmerWidget(child: ListTile(title: Text("$firstName $lastName"))),
      error: (_) => Container(),
    );
  }
}
