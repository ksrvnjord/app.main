import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_profile_widget.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakProfilePage extends StatelessWidget {
  const AlmanakProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var params = RouteData.of(context).pathParameters;

    return (params['profileId'] != null)
        ? AlmanakProfileWidget(profileId: params['profileId']!)
        : const Text('');
  }
}
