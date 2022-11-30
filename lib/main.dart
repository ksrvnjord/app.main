
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/global_observer.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Routemaster.setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  // AS Long as sentry is not working, we will not use it
  // "kReleaseMode" is true if the app is not being debugged
  // if (kReleaseMode) {
  //   // Run it inside of SentryFlutter, but log / except to the debug-app
  //   await SentryFlutter.init(
  //     (options) {
  //       options.dsn =
  //           'https://a752158d2c2d463086dde1f15e863aac@o1396616.ingest.sentry.io/6720336';
  //       options.tracesSampleRate = 0.1;
  //     },
  //     appRunner: () => () {
  //       GetIt.I.registerSingleton(GlobalObserverService());
  //       return runApp(const Application());
  //     },
  //   );
  // } else {
    GetIt.I.registerSingleton(GlobalObserverService());
    runApp(const Application());
  // }
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthModel>(create: (_) => AuthModel()),
          ChangeNotifierProxyProvider<AuthModel, GraphQLModel>(
              update: (context, auth, _) => GraphQLModel(auth),
              create: (_) => GraphQLModel(null)),
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
                    observers: [GlobalObserver()],
                    routesBuilder: (context) {
                      final auth = Provider.of<AuthModel>(context);
                      final loggedIn = auth.client != null;
                      return loggedIn ? routeMap : authenticationRoutes;
                    },
                  ),
                )));
  }
}
