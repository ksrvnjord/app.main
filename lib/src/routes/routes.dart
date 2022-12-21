import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/advalvas/pages/advalvas_page.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_web_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/events/pages/events_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/settings/pages/me_page.dart';
import 'package:ksrvnjord_main_app/src/features/settings/pages/me_privacy_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/all_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/plan_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/training_page.dart';
import 'package:ksrvnjord_main_app/src/main_page.dart';
import 'package:page_transition/page_transition.dart' as pt;
import 'package:routemaster/routemaster.dart';

class RoutedPageTransition<T> extends Page {
  final Widget child;
  final pt.PageTransitionType transition;

  const RoutedPageTransition({required this.child, required this.transition});

  @override
  Route createRoute(BuildContext context) {
    return pt.PageTransition(child: child, type: transition, settings: this);
  }
}

final routeMap = RouteMap(
  onUnknownRoute: (route) => const Redirect('/'),
  routes: {
    '/': (_) => const TabPage(
          child: MainPage(),
          paths: [
            '/home',
            '/ad-valvas',
            '/training',
            '/almanak',
          ],
          backBehavior: TabBackBehavior.none,
        ),
    '/home': (_) => const MaterialPage(
          name: 'Home',
          child: HomePage(),
        ),
    '/home/announcements/:announcementId': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: AnnouncementPage(),
        ),
    '/ad-valvas': (_) => const MaterialPage(
          name: 'Ad Valvas',
          child: AdValvasPage(),
        ),
    '/ad-valvas/announcements/:announcementId': (info) =>
        const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: AnnouncementPage(),
        ),
    '/ad-valvas/events': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: EventsPage(),
        ),
    '/almanak': (_) => const MaterialPage(
          name: 'Almanak',
          child: AlmanakPage(),
        ),
    '/almanak/:profileId': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: AlmanakProfilePage(),
        ),
    '/settings': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: MePage(),
        ),
    '/settings/privacy': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: MePrivacyPage(),
        ),
    '/training': (_) => const MaterialPage(
          name: 'Training',
          child: TrainingPage(),
        ),
    '/training/all': (_) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: AllTrainingPage(),
        ),
    '/training/all/plan': (route) => RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: PlanTrainingPage(queryParams: route.queryParameters),
        ),
    '/training/all/:id': (info) => RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: ShowTrainingPage(id: info.pathParameters['id']!),
        ),
  },
);

final authenticationRoutes = RouteMap(
  onUnknownRoute: (route) => const Redirect('/'),
  routes: {
    '/': (_) => const MaterialPage(
          name: 'Login',
          child: LoginPage(),
        ),
    '/forgot': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.fade,
          child: ForgotPage(),
        ),
    '/forgot/webview': (info) => const RoutedPageTransition(
        child: ForgotWebPage(), transition: pt.PageTransitionType.rightToLeft)
  },
);
