import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_user_profile_view.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';

class AlmanakSubstructureProfilePage extends StatelessWidget {
  const AlmanakSubstructureProfilePage({
    Key? key,
    required this.lidnummer,
  }) : super(key: key);

  final String lidnummer;

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanakprofiel"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        // we first need to query the user to get the userId
        future: almanakProfileByIdentifier(lidnummer, client),
        success: (user) => AlmanakUserProfileView(heimdallUser: user!),
        error: (error) => ErrorCardWidget(errorMessage: error.toString()),
      ),
    );
  }
}
