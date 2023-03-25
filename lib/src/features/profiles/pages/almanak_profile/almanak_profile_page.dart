import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_user_profile_view.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakProfilePage extends ConsumerWidget {
  const AlmanakProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, String> params = RouteData.of(context).pathParameters;
    final String? identifier = params['identifier']; // lidnummer of user

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanakprofiel"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: identifier != null
          ? AlmanakUserProfileView(identifier: identifier)
          : const ErrorCardWidget(errorMessage: 'Geen profiel gevonden'),
    );
  }
}
