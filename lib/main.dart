import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/routes/guards.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.gr.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  // "kReleaseMode" is true if the app is not being debugged
  if (kReleaseMode) {
    // Run it inside of SentryFlutter, but log / except to the debug-app
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://a752158d2c2d463086dde1f15e863aac@o1396616.ingest.sentry.io/6720336';
        options.tracesSampleRate = 0.1;
      },
      appRunner: () => runApp(Application()),
    );
  } else {
    // Running in debug, no need to send exceptions to Sentry
    runApp(Application());
  }
}

class Application extends StatelessWidget {
  Application({Key? key}) : super(key: key);

  final _appRouter = AppRouter(authGuard: AuthGuard());

  @override
  Widget build(BuildContext context) {
    // Initialize the root application with the Authentication Model,
    // as this defines if we'll show the login screen or the application
    // itself.
    return ChangeNotifierProvider(
        create: (context) => AuthModel(),
        child: MaterialApp.router(
          title: 'K.S.R.V. Njord',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.ibmPlexSansTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          debugShowCheckedModeBanner: false,
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ));
  }
}
