import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_web_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/register_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/register_web_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_edit_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_list_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_show_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_create_page.dart';
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
import 'package:routemaster/routemaster.dart';

// TODO: Use different file for this class?
// ignore: prefer-match-file-name

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
    '/home': (_) => const CupertinoPage(
          name: 'Home',
          child: HomePage(),
        ),
    '/home/announcements/:announcementId': (_) => const CupertinoPage(
          child: AnnouncementPage(),
          name: "Aankondiging",
        ),
    '/calendar': (info) => const CupertinoPage(
          name: "Agenda",
          child: EventsPage(),
        ),
    '/almanak': (_) => const CupertinoPage(
          name: 'Almanak',
          child: AlmanakPage(),
        ),
    '/almanak/edit': (_) => const CupertinoPage(
          child: EditAlmanakProfilePage(),
        ),
    '/almanak/edit/visibility': (info) => const CupertinoPage(
          child: MePrivacyPage(),
        ),
    '/almanak/:profileId': (info) => const CupertinoPage(
          child: AlmanakProfilePage(),
        ),
    '/settings': (info) => const CupertinoPage(
          child: MePage(),
        ),
    '/training': (_) => const CupertinoPage(
          name: 'Training',
          child: TrainingPage(),
        ),
    '/training/all': (_) => const CupertinoPage(
          child: AllTrainingPage(),
        ),
    '/training/all/plan': (route) => CupertinoPage(
          child: PlanTrainingPage(queryParams: route.queryParameters),
        ),
    '/training/all/:id': (info) => CupertinoPage(
          child: ShowTrainingPage(id: info.pathParameters['id']!),
        ),
    '/training/all/damages': (route) =>
        const CupertinoPage(child: DamagesListPage()),
    '/training/all/damages/create': (route) =>
        const CupertinoPage(child: DamagesCreatePage()),
    '/training/all/damages/:reservationObjectId': (route) => CupertinoPage(
          child: DamagesListPage(
            reservationObjectId: route.pathParameters['reservationObjectId']!,
          ),
        ),
    '/training/all/damages/:reservationObjectId/edit': (route) => CupertinoPage(
          child: DamagesEditPage(
            id: route.queryParameters['id']!,
            reservationObjectId: route.pathParameters['reservationObjectId']!,
          ),
        ),
    '/training/all/damages/:reservationObjectId/show': (route) => CupertinoPage(
          child: DamagesShowPage(
            id: route.queryParameters['id']!,
            reservationObjectId: route.pathParameters['reservationObjectId']!,
          ),
        ),
    '/training/all/damages/:reservationObjectId/create': (route) =>
        CupertinoPage(
          child: DamagesCreatePage(
            reservationObjectId: route.pathParameters['reservationObjectId']!,
          ),
        ),
    '/training/all/reservationObject/:reservationObjectId': (route) =>
        CupertinoPage(
          child: ShowReservationObjectPage(
            documentId: route.pathParameters['reservationObjectId']!,
            name: route.queryParameters['name']!,
          ),
        ),
    '/more': (route) => const CupertinoPage(
          name: 'More',
          child: MorePage(),
        ),
    '/more/events': (info) => const CupertinoPage(
          child: EventsPage(),
        ),
    '/more/beleid': (info) => const CupertinoPage(
          child: BeleidPage(),
        ),
    '/contact': (route) => const CupertinoPage(
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
    '/forgot': (info) => const CupertinoPage(
          child: ForgotPasswordPage(),
        ),
    '/forgot/webview': (info) => const CupertinoPage(
          child: ForgotPasswordWebPage(),
        ),
    '/register': (_) => const CupertinoPage(
          child: RegisterPage(),
        ),
    '/register/webview': (info) => const CupertinoPage(
          child: RegisterWebPage(),
        ),
  },
);
