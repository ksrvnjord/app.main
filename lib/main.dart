import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  Routemaster.setPathUrlStrategy();

  // "kReleaseMode" is true if the app is not being debugged
  if (kReleaseMode) {
    // Run it inside of SentryFlutter, but log / except to the debug-app
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://a752158d2c2d463086dde1f15e863aac@o1396616.ingest.sentry.io/6720336';
        options.tracesSampleRate = 0.1;
      },
      appRunner: () => () {
        return runApp(const Application());
      },
    );
  } else {
    runApp(const Application());
  }
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthModel>(create: (_) => AuthModel()),
          ChangeNotifierProvider<GraphQLModel>(create: (_) => GraphQLModel()),
        ],
        child: Builder(
            builder: (context) => MaterialApp.router(
                  title: 'K.S.R.V. Njord',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    textTheme: GoogleFonts.ibmPlexSansTextTheme(
                      Theme.of(context).textTheme,
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  routeInformationParser: const RoutemasterParser(),
                  routerDelegate: RoutemasterDelegate(
                    routesBuilder: (context) {
                      final auth = Provider.of<AuthModel>(context);
                      final loggedIn = auth.client != null;
                      return loggedIn ? routeMap : loggedOutRouteMap;
                    },
                  ),
                )));
  }
}
