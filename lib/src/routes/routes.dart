import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_web_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/register_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/register_web_page.dart';
import 'package:ksrvnjord_main_app/src/features/posts/pages/comments_page.dart';
import 'package:ksrvnjord_main_app/src/features/posts/pages/create_post_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_edit_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_list_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_show_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_create_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/events/pages/events_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/advanced_settings_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/beleid_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/contact_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/more_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/notifications_page.dart';
import 'package:ksrvnjord_main_app/src/features/posts/pages/posts_page.dart';
import 'package:ksrvnjord_main_app/src/features/polls/pages/polls_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/houses.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_bestuur_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_commissie_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_huis_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_leeden_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_substructuur_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/choice_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/commissie_choice_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/pages/edit_almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/pages/edit_commissies_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/pages/fill_commissie_info_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/pages/select_commissie_page.dart';
import 'package:ksrvnjord_main_app/src/features/settings/pages/me_page.dart';
import 'package:ksrvnjord_main_app/src/features/settings/pages/me_privacy_page.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/commissies.dart';
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
            '/posts',
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
    '/home/polls': (_) => const CupertinoPage(
          name: 'Polls',
          child: PollsPage(),
        ),
    '/home/announcements/:announcementId': (_) => const CupertinoPage(
          child: AnnouncementPage(),
          name: "Aankondiging",
        ),
    '/posts': (_) => const CupertinoPage(name: "Prikbord", child: PostsPage()),
    '/posts/new': (_) => const CupertinoPage(child: CreatePostPage()),
    '/posts/:postId/comments': (route) => CupertinoPage(
          child: CommentsPage(
            postDocId: Uri.decodeFull(route.pathParameters['postId']!),
          ),
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
    '/almanak/edit/commissies': (info) => const CupertinoPage(
          child: EditCommissiesPage(),
        ),
    '/almanak/edit/commissies/select': (info) => const CupertinoPage(
          child: SelectCommissiePage(),
        ),
    '/almanak/edit/commissies/select/fill-info': (info) => CupertinoPage(
          child: FillCommissieInfoPage(
            commissie: info.queryParameters['commissie']!,
          ),
        ),
    '/almanak/edit/visibility': (info) => const CupertinoPage(
          child: MePrivacyPage(),
        ),
    '/almanak/leeden': (_) => const CupertinoPage(
          name: 'Leeden',
          child: AlmanakLeedenPage(),
        ),
    '/almanak/bestuur': (_) => const CupertinoPage(
          name: 'Bestuur',
          child: AlmanakBestuurPage(),
        ),
    '/almanak/bestuur/:identifier': (route) => CupertinoPage(
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/commissies': (_) => CupertinoPage(
          name: 'Commissies',
          child: CommissieChoicePage(
            title: "Commissies",
            choices: commissieEmailMap.keys.toList(),
            pushRoute: 'leeden',
            queryParameterName: 'commissie',
          ),
        ),
    '/almanak/commissies/leeden': (route) => CupertinoPage(
          name: 'Commissie',
          child: AlmanakCommissiePage(
            commissieName: route.queryParameters['commissie']!,
          ),
        ),
    '/almanak/commissies/leeden/:identifier': (route) => CupertinoPage(
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/huizen': (_) => const CupertinoPage(
          name: 'Huizen',
          child: ChoicePage(
            title: "Huizen",
            choices: houseNames,
            pushRoute: 'leeden',
            queryParameterName: 'huis',
          ),
        ),
    '/almanak/huizen/leeden': (route) => CupertinoPage(
          name: 'Huizen',
          child: AlmanakHuisPage(
            houseName: route.queryParameters['huis']!,
          ),
        ),
    '/almanak/huizen/leeden/:identifier': (route) => CupertinoPage(
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/substructuren': (_) => CupertinoPage(
          name: 'Substructuren',
          child: ChoicePage(
            title: "Substructuren",
            choices: substructures.toList(),
            pushRoute: 'leeden',
            queryParameterName: 'substructuur',
          ),
        ),
    '/almanak/substructuren/leeden': (route) => CupertinoPage(
          name: 'Substructuren',
          child: AlmanakSubstructuurPage(
            substructuurName: route.queryParameters['substructuur']!,
          ),
        ),
    '/almanak/substructuren/leeden/:identifier': (route) => CupertinoPage(
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/leeden/:identifier': (route) => CupertinoPage(
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/settings': (info) => const CupertinoPage(
          child: MePage(),
        ),
    '/training': (_) => const CupertinoPage(
          name: 'Training',
          child: TrainingPage(),
        ),
    '/training/createdamage': (route) => CupertinoPage(
          child: DamagesCreatePage(
            reservationObjectId: route.queryParameters['reservationObjectId'],
          ),
        ),
    '/training/damages': (route) =>
        const CupertinoPage(child: DamagesListPage()),
    '/training/damages/create': (route) => CupertinoPage(
          child: DamagesCreatePage(
            reservationObjectId: route.queryParameters['reservationObjectId'],
          ),
        ),
    '/training/damages/edit': (route) => CupertinoPage(
          child: DamagesEditPage(
            id: route.queryParameters['id']!,
            reservationObjectId: route.queryParameters['reservationObjectId']!,
          ),
        ),
    '/training/damages/show': (route) => CupertinoPage(
          child: DamagesShowPage(
            id: route.queryParameters['id']!,
            reservationObjectId: route.queryParameters['reservationObjectId']!,
          ),
        ),
    '/training/all': (_) => CupertinoPage(
          child: AllTrainingPage(),
        ),
    '/training/all/plan': (route) => CupertinoPage(
          child: PlanTrainingPage(queryParams: route.queryParameters),
        ),
    '/training/all/:id': (info) => CupertinoPage(
          child: ShowTrainingPage(id: info.pathParameters['id']!),
        ),
    '/training/all/reservationObject/:reservationObjectId': (route) =>
        CupertinoPage(
          child: ShowReservationObjectPage(
            documentId: route.pathParameters['reservationObjectId']!,
            name: route.queryParameters['name']!,
          ),
        ),
    '/training/all/reservationObject/:reservationObjectId/damage/edit':
        (route) => CupertinoPage(
              child: DamagesEditPage(
                id: route.queryParameters['id']!,
                reservationObjectId:
                    route.pathParameters['reservationObjectId']!,
              ),
            ),
    '/training/all/reservationObject/:reservationObjectId/damage/show':
        (route) => CupertinoPage(
              child: DamagesShowPage(
                id: route.queryParameters['id']!,
                reservationObjectId:
                    route.pathParameters['reservationObjectId']!,
              ),
            ),
    '/training/all/reservationObject/:reservationObjectId/damage/create':
        (route) => CupertinoPage(
              child: DamagesCreatePage(
                reservationObjectId:
                    route.pathParameters['reservationObjectId']!,
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
    '/more/notifications': (info) => const CupertinoPage(
          child: NotificationsPage(),
        ),
    '/more/advanced-settings': (_) => const CupertinoPage(
          child: AdvancedSettingsPage(),
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
