import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
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
import 'package:ksrvnjord_main_app/src/features/profiles/choice/ploeg_choice_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/houses.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/add_ploeg_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/edit_groups_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/select_ploeg_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/leeden/pages/almanak_leeden_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/choice_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/commissie_choice_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/substructure_choice_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/edit_almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/edit_commissies_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/fill_commissie_info_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/select_commissie_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/pages/almanak_bestuur_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/pages/almanak_commissie_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/pages/almanak_huis_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/pages/almanak_ploeg_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/pages/almanak_substructuur_page.dart';
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
          child: HomePage(),
          name: 'Home',
        ),
    '/home/edit': (_) => const CupertinoPage(
          child: EditAlmanakProfilePage(),
          name: "Edit Profile",
        ),
    '/home/edit/:identifier': (route) => CupertinoPage(
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
          name: "Preview my profile",
        ),
    '/home/edit/groups': (_) =>
        const CupertinoPage(child: EditGroupsPage(), name: "Edit my groups"),
    '/home/edit/groups/ploeg': (_) => const CupertinoPage(
          child: SelectPloegPage(),
          name: "Select a ploeg to add",
        ),
    '/home/edit/groups/ploeg/add': (_) =>
        const CupertinoPage(child: AddPloegPage(), name: "Add a ploeg"),
    '/home/edit/commissies': (info) => const CupertinoPage(
          child: EditCommissiesPage(),
          name: "Edit my commissies",
        ),
    '/home/edit/commissies/select': (info) => const CupertinoPage(
          name: "Select a commissie to add",
          child: SelectCommissiePage(),
        ),
    '/home/edit/commissies/select/fill-info': (info) => CupertinoPage(
          name: "Fill commissie info",
          child: FillCommissieInfoPage(
            commissie: info.queryParameters['commissie']!,
          ),
        ),
    '/home/edit/visibility': (info) => const CupertinoPage(
          name: "Edit my visibility",
          child: MePrivacyPage(),
        ),
    '/home/polls': (_) => const CupertinoPage(
          name: 'Polls',
          child: PollsPage(),
        ),
    '/home/events': (info) => const CupertinoPage(
          name: "Events",
          child: EventsPage(),
        ),
    '/home/announcements/:announcementId': (_) => const CupertinoPage(
          name: "Announcement",
          child: AnnouncementPage(),
        ),
    '/posts': (_) => const CupertinoPage(
          name: "Posts",
          child: PostsPage(),
        ),
    '/posts/new': (_) => const CupertinoPage(
          name: "New Post",
          child: CreatePostPage(),
        ),
    '/posts/:postId/comments': (route) => CupertinoPage(
          name: "Comments",
          child: CommentsPage(
            postDocId: Uri.decodeFull(route.pathParameters['postId']!),
          ),
        ),
    '/calendar': (info) => const CupertinoPage(
          name: "Calendar",
          child: EventsPage(),
        ),
    '/almanak': (_) => const CupertinoPage(
          name: 'Almanak',
          child: AlmanakPage(),
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
          name: 'Bestuurslid',
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/commissies': (_) => CupertinoPage(
          name: 'Commissies',
          child: CommissieChoicePage(
            title: "Commissies",
            choices: commissieEmailMap.keys.toList(),
          ),
        ),
    '/almanak/commissies/:commissie': (route) => CupertinoPage(
          name: 'Commissie',
          child: AlmanakCommissiePage(
            commissieName: Uri.decodeFull(route.pathParameters['commissie']!),
          ),
        ),
    '/almanak/commissies/:commissie/:identifier': (route) => CupertinoPage(
          name: 'Commissielid',
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/ploegen': (_) => const CupertinoPage(
          name: 'Ploegen',
          child: PloegChoicePage(),
        ),
    '/almanak/ploegen/:ploeg': (route) => CupertinoPage(
          name: 'Ploeg',
          child: AlmanakPloegPage(
            ploegName: Uri.decodeFull(route.pathParameters['ploeg']!),
          ),
        ),
    '/almanak/ploegen/:ploeg/:userId': (route) => CupertinoPage(
          name: 'Ploeglid',
          child: AlmanakProfilePage(
            userId: route.pathParameters['userId']!,
          ),
        ),
    '/almanak/huizen': (_) => const CupertinoPage(
          name: 'Huizen',
          child: ChoicePage(
            title: "Huizen",
            choices: houseNames,
          ),
        ),
    '/almanak/huizen/:huis': (route) => CupertinoPage(
          name: 'Huis',
          child: AlmanakHuisPage(
            houseName: Uri.decodeFull(route.pathParameters['huis']!),
          ),
        ),
    '/almanak/huizen/:huis/:identifier': (route) => CupertinoPage(
          name: 'Huisgenoot',
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/substructuren': (_) => CupertinoPage(
          name: 'Substructuren',
          child: SubstructureChoicePage(
            title: "Substructuren",
            choices: substructures.toList(),
          ),
        ),
    '/almanak/substructuren/:substructuur': (route) => CupertinoPage(
          name: 'Substructuur',
          child: AlmanakSubstructuurPage(
            name: Uri.decodeFull(
              route.pathParameters['substructuur']!,
            ),
          ),
        ),
    '/almanak/substructuren/:substructuur/:identifier': (route) =>
        CupertinoPage(
          name: 'Substructuurlid',
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/almanak/leeden/:identifier': (route) => CupertinoPage(
          name: 'Lid',
          child: AlmanakProfilePage(
            userId: route.pathParameters['identifier']!,
          ),
        ),
    '/settings': (info) => const CupertinoPage(
          name: "Settings",
          child: MePage(),
        ),
    '/training': (_) => const CupertinoPage(
          name: 'Training',
          child: TrainingPage(),
        ),
    '/training/damages': (route) => const CupertinoPage(
          name: 'Damages',
          child: DamagesListPage(),
        ),
    '/training/damages/create': (route) => CupertinoPage(
          name: "Create Damage",
          child: DamagesCreatePage(
            reservationObjectId: route.queryParameters['reservationObjectId'],
          ),
        ),
    '/training/damages/edit': (route) => CupertinoPage(
          name: "Edit Damage",
          child: DamagesEditPage(
            id: route.queryParameters['id']!,
            reservationObjectId: route.queryParameters['reservationObjectId']!,
          ),
        ),
    '/training/damages/show': (route) => CupertinoPage(
          name: "Show Damage",
          child: DamagesShowPage(
            id: route.queryParameters['id']!,
            reservationObjectId: route.queryParameters['reservationObjectId']!,
          ),
        ),
    '/training/all': (_) => CupertinoPage(
          name: 'All Training',
          child: AllTrainingPage(),
        ),
    '/training/all/plan': (route) => CupertinoPage(
          name: 'Plan Training',
          child: PlanTrainingPage(queryParams: route.queryParameters),
        ),
    '/training/all/:id': (info) => CupertinoPage(
          name: 'Show Training',
          child: ShowTrainingPage(id: info.pathParameters['id']!),
        ),
    '/training/all/reservationObject/:reservationObjectId': (route) =>
        CupertinoPage(
          name: 'Show Reservation Object',
          child: ShowReservationObjectPage(
            documentId: route.pathParameters['reservationObjectId']!,
            name: route.queryParameters['name']!,
          ),
        ),
    '/training/all/reservationObject/:reservationObjectId/damage/edit':
        (route) => CupertinoPage(
              name: 'Edit Damage',
              child: DamagesEditPage(
                id: route.queryParameters['id']!,
                reservationObjectId:
                    route.pathParameters['reservationObjectId']!,
              ),
            ),
    '/training/all/reservationObject/:reservationObjectId/damage/show':
        (route) => CupertinoPage(
              name: 'Show Damage',
              child: DamagesShowPage(
                id: route.queryParameters['id']!,
                reservationObjectId:
                    route.pathParameters['reservationObjectId']!,
              ),
            ),
    '/training/all/reservationObject/:reservationObjectId/damage/create':
        (route) => CupertinoPage(
              name: 'Create Damage',
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
          name: 'Events',
          child: EventsPage(),
        ),
    '/more/beleid': (info) => const CupertinoPage(
          name: 'Beleid',
          child: BeleidPage(),
        ),
    '/more/notifications': (info) => const CupertinoPage(
          name: 'Notifications',
          child: NotificationsPage(),
        ),
    '/more/advanced-settings': (_) => const CupertinoPage(
          name: 'Advanced Settings',
          child: AdvancedSettingsPage(),
        ),
    '/contact': (route) => const CupertinoPage(
          name: 'Contact',
          child: ContactPage(),
        ),
  },
  onUnknownRoute: (route) => const Redirect('/'),
);

final authenticationRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginPage(),
          name: 'Login',
        ),
    '/forgot': (info) => const CupertinoPage(
          child: ForgotPasswordPage(),
        ),
  },
  onUnknownRoute: (route) => const Redirect('/'),
);
