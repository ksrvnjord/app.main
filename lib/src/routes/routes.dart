import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcements_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile_page.dart';
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

// This is the logged out route map.
// This only allows the user to navigate to the root path.
// Note: building the route map from methods allows hot reload to work
final loggedOutRouteMap = RouteMap(
  onUnknownRoute: (route) => const Redirect('/'),
  routes: {
    '/': (_) => const MaterialPage(child: LoginPage()),
  },
);

final routeMap = RouteMap(
  onUnknownRoute: (route) => const Redirect('/'),
  routes: {
    '/': (_) => const TabPage(
          child: MainPage(),
          paths: [
            '/home',
            '/announcements',
            '/almanak',
          ],
          backBehavior: TabBackBehavior.none,
        ),
    '/home': (_) => const MaterialPage(
          name: 'Home',
          child: HomePage(),
        ),
    '/announcements': (_) => const MaterialPage(
          name: 'Announcements',
          child: AnnouncementsPage(),
        ),
    '/announcements/:announcementId': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: AnnouncementPage(),
        ),
    '/almanak': (_) => const MaterialPage(
          name: 'Almanak',
          child: AlmanakPage(),
        ),
    '/almanak/:profileId': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: AlmanakProfilePage(),
        ),
  },
);
