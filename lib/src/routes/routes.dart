import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcements_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/main_page.dart';
import 'package:routemaster/routemaster.dart';

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
    '/announcements/:announcementId': (info) => const MaterialPage(
          name: 'Announcement',
          child: AnnouncementPage(),
        ),
    '/almanak': (_) => const MaterialPage(
          name: 'Almanak',
          child: AlmanakPage(),
        ),
  },
);
