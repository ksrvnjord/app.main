import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakUserTile extends StatefulWidget {
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
  AlmanakUserTileState createState() => AlmanakUserTileState();
}

class AlmanakUserTileState extends State<AlmanakUserTile> {
  String? heimdallUserId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return FutureWrapper(
      future: almanakProfileByIdentifier(widget.lidnummer, client),
      success: (_) => ListTile(
        leading: ProfilePictureWidget(userId: widget.lidnummer),
        title: Text("${widget.firstName} ${widget.lastName}"),
        subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
        onTap: () => Routemaster.of(context).push(heimdallUserId!),
      ),
      loading: const ShimmerWidget(
        child: ListTile(
          leading: ShimmerWidget(child: DefaultProfilePicture()),
          title: ShimmerWidget(child: SizedBox(height: 20, width: 100)),
        ),
      ),
    ); // show nothing if no heimdall user is found
  }
}
