import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_web_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/register_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/register_web_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/events/pages/events_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/beleid_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/contact_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/more_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/edit_almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/settings/pages/me_page.dart';
import 'package:ksrvnjord_main_app/src/features/settings/pages/me_privacy_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/all_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/plan_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_reservation_object_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/training_page.dart';
import 'package:ksrvnjord_main_app/src/main_page.dart';
import 'package:page_transition/page_transition.dart' as pt;
import 'package:routemaster/routemaster.dart';

// TODO: Use different file for this class?
// ignore: prefer-match-file-name
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
            '/calendar',
            '/training',
            '/almanak',
            '/more',
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
    '/calendar': (info) => const MaterialPage(
          name: "Agenda",
          child: EventsPage(),
        ),
    '/almanak': (_) => const MaterialPage(
          name: 'Almanak',
          child: AlmanakPage(),
        ),
    '/almanak/edit': (_) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: EditAlmanakProfilePage(),
        ),
    '/almanak/edit/visibility': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: MePrivacyPage(),
        ),
    '/almanak/:profileId': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: AlmanakProfilePage(),
        ),
    '/settings': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: MePage(),
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
    '/training/all/reservationObject/:id': (route) => RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: ShowReservationObjectPage(
            documentId: route.pathParameters['id']!,
            name: route.queryParameters['name']!,
          ),
        ),
    '/more': (route) => const MaterialPage(
          name: 'More',
          child: MorePage(),
        ),
    '/more/events': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: EventsPage(),
        ),
    '/more/beleid': (info) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: BeleidPage(),
        ),
    '/contact': (route) => const RoutedPageTransition(
          transition: pt.PageTransitionType.rightToLeft,
          child: ContactPage(),
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
          child: ForgotPasswordPage(),
        ),
    '/forgot/webview': (info) => const RoutedPageTransition(
          child: ForgotPasswordWebPage(),
          transition: pt.PageTransitionType.rightToLeft,
        ),
    '/register': (_) => const RoutedPageTransition(
          transition: pt.PageTransitionType.fade,
          child: RegisterPage(),
        ),
    '/register/webview': (info) => const RoutedPageTransition(
          child: RegisterWebPage(),
          transition: pt.PageTransitionType.rightToLeft,
        ),
  },
);
