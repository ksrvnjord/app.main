// ignore_for_file: prefer-static-class
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'firebase_options.dart';
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/global_constants.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/global_observer_service.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/image_cache_item.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:stack_trace/stack_trace.dart' as stack_trace;

@pragma('vm:entry-point')
// ignore: no-empty-block,avoid-redundant-async
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage _) async {}

Future<void> appRunner() async {
  // ignore: avoid-ignoring-return-values
  WidgetsFlutterBinding.ensureInitialized();
  Routemaster.setPathUrlStrategy();
  // ignore: avoid-ignoring-return-values
  await Firebase.initializeApp(
    // Can't add name: 'ksrv-njord', // we can't pass name due to a bug: https://github.com/firebase/flutterfire/issues/10228.
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider:
        kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics.
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

    return true;
  };

  if (!kIsWeb) {
    // FirebaseMessaging not implemented on Web yet.
    // ignore: avoid-ignoring-return-values
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // ignore: avoid-ignoring-return-values
  GetIt.I.registerSingleton(GlobalObserverService());
  // ignore: avoid-ignoring-return-values
  GetIt.I.registerSingleton(GlobalConstants());
  // ignore: avoid-ignoring-return-values
  GetIt.I.registerSingleton(CurrentUser());

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  if (!kIsWeb) {
    // DefaultEventParameters are not supported on web.
    await FirebaseAnalytics.instance.setDefaultEventParameters(
      {'version': packageInfo.version},
    ); // Log app version with every event.
  }

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
    kReleaseMode,
  ); // Don't collect analytics in debug mode.

  runApp(const BetterFeedback(
    child: ProviderScope(
      child: Application(),
    ),
  ));
}

Future<void> main() async {
  FlutterError.demangleStackTrace = (StackTrace stack) {
    // Riverpod uses different format of stack trace than flutter, so we need to convert it to flutter format.
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;

    return stack;
  };
  // Initialize the Hive Cache (Generic K/V cache, relevant for image caching).
  await Hive.initFlutter(
    HiveCache.cachePath,
  ); // Store the cache in a separate folder.
  Hive.registerAdapter(ImageCacheItemAdapter()); // For image caching.
  // ignore: avoid-ignoring-return-values
  await Hive.openLazyBox<ImageCacheItem>('imageCache');

  timeago.setLocaleMessages('nl', timeago.NlMessages());
  timeago.setLocaleMessages('nl_short', timeago.NlShortMessages());

  // Note: "kReleaseMode" is true if the app is not being debugged.
  if (kReleaseMode) {
    // Run it inside of SentryFlutter, but log / except to the debug-app.
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

// Main is not a nice class name, but it is the main class of the app.
// ignore: prefer-match-file-name
class Application extends ConsumerWidget {
  const Application({Key? key}) : super(key: key);

  RouteMap getRoutes(WidgetRef ref) {
    final auth = ref.watch(authModelProvider);
    final loggedIn = auth.client != null;

    return loggedIn ? Routes.authenticated : Routes.unauthenticated;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initializeDateFormatting('nl_NL');

    return Builder(
      builder: (context) => MaterialApp.router(
        routeInformationParser: const RoutemasterParser(),
        routerDelegate: RoutemasterDelegate(
          routesBuilder: (context) => getRoutes(ref),
          observers: [
            GlobalObserver(),
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
        ),
        title: 'K.S.R.V. Njord',
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          }),
          primarySwatch: Colors.blue,
          textTheme:
              GoogleFonts.ibmPlexSansTextTheme(Theme.of(context).textTheme),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('nl', 'NL')],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
