import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/global_constants.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/global_observer_service.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/image_cache_item.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:timeago/timeago.dart' as timeago;

@pragma('vm:entry-point')
// ignore: no-empty-block,avoid-redundant-async
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage _) async {}

Future<void> appRunner() async {
  WidgetsFlutterBinding.ensureInitialized();
  Routemaster.setPathUrlStrategy();
  await Firebase.initializeApp(
    name: 'ksrv-njord',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // activate AppCheck
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider:
        kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
  );

  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  GetIt.I.registerSingleton(GlobalObserverService());
  GetIt.I.registerSingleton(GlobalConstants());
  GetIt.I.registerSingleton(CurrentUser());

  runApp(const BetterFeedback(
    child: Application(),
  ));
}

Future<void> main() async {
  // Initialize the Hive Cache (Generic K/V cache, relevant for image caching)
  await Hive.initFlutter(
    HiveCache.cachePath,
  ); // store the cache in a separate folder
  Hive.registerAdapter(ImageCacheItemAdapter()); // for image caching
  Hive.openLazyBox<ImageCacheItem>('imageCache');

  timeago.setLocaleMessages('nl', timeago.NlMessages());
  timeago.setLocaleMessages('nl_short', timeago.NlShortMessages());

  // "kReleaseMode" is true if the app is not being debugged
  if (kReleaseMode) {
    // Run it inside of SentryFlutter, but log / except to the debug-app
    const double sampleRate = 1;
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://d45c56c8f63a498188d63af3c1cf585d@sentry.ksrv.nl/3';
        options.tracesSampleRate = sampleRate;
      },
      appRunner: appRunner,
    );
  } else {
    appRunner();
  }
}

// Main is not a nice class name, but it is the main class of the app
// ignore: prefer-match-file-name
class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  RouteMap getRoutes(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    final loggedIn = auth.client != null;

    return loggedIn ? routeMap : authenticationRoutes;
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('nl_NL');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(create: (_) => AuthModel()),
        ChangeNotifierProxyProvider<AuthModel, GraphQLModel>(
          update: (context, auth, _) => GraphQLModel(auth),
          create: (_) => GraphQLModel(null),
        ),
      ],
      child: riverpod.ProviderScope(
        // store state of Riverpod providers
        child: Builder(
          builder: (context) => MaterialApp.router(
            title: 'K.S.R.V. Njord',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.ibmPlexSansTextTheme(
                Theme.of(context).textTheme,
              ),
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                // this is to use swipe transitions on iOS
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
                TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
                TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
              }),
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('nl', 'NL'),
            ],
            debugShowCheckedModeBanner: false,
            routeInformationParser: const RoutemasterParser(),
            routerDelegate: RoutemasterDelegate(
              observers: [GlobalObserver()],
              routesBuilder: getRoutes,
            ),
          ),
        ),
      ),
    );
  }
}
