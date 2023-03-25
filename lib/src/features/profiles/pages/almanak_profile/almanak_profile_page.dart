import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_user_profile_view.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:routemaster/routemaster.dart';
import '../../../shared/model/graphql_model.dart';

class AlmanakProfilePage extends ConsumerWidget {
  const AlmanakProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, String> params = RouteData.of(context).pathParameters;
    final client = ref.watch(graphQLModelProvider).client;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanakprofiel"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: params['identifier'] != null
          ? FutureWrapper(
              // we first need to query the user to get the userId
              future: almanakProfileByIdentifier(params['identifier']!, client),
              success: (user) => AlmanakUserProfileView(heimdallUser: user!),
              error: (error) => ErrorCardWidget(errorMessage: error.toString()),
            )
          : const ErrorCardWidget(errorMessage: 'Geen profiel gevonden'),
    );
  }
}
