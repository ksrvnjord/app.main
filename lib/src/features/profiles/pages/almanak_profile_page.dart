import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_profile_widget.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakProfilePage extends StatelessWidget {
  const AlmanakProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var params = RouteData.of(context).pathParameters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Almanak'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: (params['profileId'] != null)
          ? AlmanakProfileWidget(profileId: params['profileId']!)
          : const Text(''),
    );
  }
}
