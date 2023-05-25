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
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/edit_allergies_page.dart';
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
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_main_page.dart';
import 'package:ksrvnjord_main_app/src/main_page.dart';
import 'package:routemaster/routemaster.dart';

// TODO: Use different file for this class?
// ignore: prefer-match-file-name

@immutable
class Routes {
  static final authenticated = RouteMap(
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
      '/home/edit/sensitive-data': (info) => const CupertinoPage(
            child: MePage(),
            name: "Edit mijn personal data",
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
            child: SelectCommissiePage(),
            name: "Select a commissie to add",
          ),
      '/home/edit/commissies/select/fill-info': (info) => CupertinoPage(
            child: FillCommissieInfoPage(
              commissie: info.queryParameters['commissie']!,
            ),
            name: "Fill commissie info",
          ),
      '/home/edit/notification-preferences': (info) => const CupertinoPage(
            child: NotificationsPage(),
            name: 'Notification Preferences',
          ),
      '/home/edit/visibility': (info) => const CupertinoPage(
            child: MePrivacyPage(),
            name: "Edit my visibility",
          ),
      '/home/edit/allergies': (info) => const CupertinoPage(
            child: EditAllergiesPage(),
            name: "Edit my allergies",
          ),
      '/home/polls': (_) =>
          const CupertinoPage(child: PollsPage(), name: 'Polls'),
      '/home/events': (info) =>
          const CupertinoPage(child: EventsPage(), name: "Events"),
      '/home/announcements/:announcementId': (_) =>
          const CupertinoPage(child: AnnouncementPage(), name: "Announcement"),
      '/posts': (_) => const CupertinoPage(child: PostsPage(), name: "Posts"),
      '/posts/new': (_) =>
          const CupertinoPage(child: CreatePostPage(), name: "New Post"),
      '/posts/:postId/comments': (route) => CupertinoPage(
            child: CommentsPage(
              postDocId: Uri.decodeFull(route.pathParameters['postId']!),
            ),
            name: "Post -> Comments",
          ),
      '/almanak': (_) =>
          const CupertinoPage(child: AlmanakPage(), name: 'Almanak'),
      '/almanak/leeden': (_) =>
          const CupertinoPage(child: AlmanakLeedenPage(), name: 'Leeden'),
      '/almanak/bestuur': (_) =>
          const CupertinoPage(child: AlmanakBestuurPage(), name: 'Bestuur'),
      '/almanak/bestuur/:identifier': (route) => CupertinoPage(
            child:
                AlmanakProfilePage(userId: route.pathParameters['identifier']!),
            name: 'Bestuurslid',
          ),
      '/almanak/commissies': (_) => CupertinoPage(
            child: CommissieChoicePage(
              title: "Commissies",
              choices: commissieEmailMap.keys.toList(),
            ),
            name: 'Commissies',
          ),
      '/almanak/commissies/:commissie': (route) => CupertinoPage(
            child: AlmanakCommissiePage(
              commissieName: Uri.decodeFull(route.pathParameters['commissie']!),
            ),
            name: 'Commissie',
          ),
      '/almanak/commissies/:commissie/:identifier': (route) => CupertinoPage(
            child:
                AlmanakProfilePage(userId: route.pathParameters['identifier']!),
            name: 'Commissielid',
          ),
      '/almanak/ploegen': (_) =>
          const CupertinoPage(child: PloegChoicePage(), name: 'Ploegen'),
      '/almanak/ploegen/:ploeg': (route) => CupertinoPage(
            child: AlmanakPloegPage(
              ploegName: Uri.decodeFull(route.pathParameters['ploeg']!),
            ),
            name: 'Ploeg',
          ),
      '/almanak/ploegen/:ploeg/:userId': (route) => CupertinoPage(
            child: AlmanakProfilePage(userId: route.pathParameters['userId']!),
            name: 'Ploeglid',
          ),
      '/almanak/huizen': (_) => const CupertinoPage(
            child: ChoicePage(title: "Huizen", choices: houseNames),
            name: 'Huizen',
          ),
      '/almanak/huizen/:huis': (route) => CupertinoPage(
            child: AlmanakHuisPage(
              houseName: Uri.decodeFull(route.pathParameters['huis']!),
            ),
            name: 'Huis',
          ),
      '/almanak/huizen/:huis/:identifier': (route) => CupertinoPage(
            child:
                AlmanakProfilePage(userId: route.pathParameters['identifier']!),
            name: 'Huisgenoot',
          ),
      '/almanak/substructuren': (_) => CupertinoPage(
            child: SubstructureChoicePage(
              title: "Substructuren",
              choices: substructures.toList(),
            ),
            name: 'Substructuren',
          ),
      '/almanak/substructuren/:substructuur': (route) => CupertinoPage(
            child: AlmanakSubstructuurPage(
              name: Uri.decodeFull(route.pathParameters['substructuur']!),
            ),
            name: 'Substructuur',
          ),
      '/almanak/substructuren/:substructuur/:identifier': (route) =>
          CupertinoPage(
            child:
                AlmanakProfilePage(userId: route.pathParameters['identifier']!),
            name: 'Substructuurlid',
          ),
      '/almanak/leeden/:identifier': (route) => CupertinoPage(
            child:
                AlmanakProfilePage(userId: route.pathParameters['identifier']!),
            name: 'Lid',
          ),
      '/training': (_) =>
          const CupertinoPage(child: TrainingPage(), name: 'Training'),
      '/training/damages': (route) =>
          const CupertinoPage(child: DamagesListPage(), name: 'Damages'),
      '/training/damages/create': (route) => CupertinoPage(
            child: DamagesCreatePage(
              reservationObjectId: route.queryParameters['reservationObjectId'],
            ),
            name: "Create Damage",
          ),
      '/training/damages/edit': (route) => CupertinoPage(
            child: DamagesEditPage(
              damageDocumentId: route.queryParameters['id']!,
              reservationObjectId:
                  route.queryParameters['reservationObjectId']!,
            ),
            name: "Edit Damage",
          ),
      '/training/damages/show': (route) => CupertinoPage(
            child: DamagesShowPage(
              damageDocumentId: route.queryParameters['id']!,
              reservationObjectId:
                  route.queryParameters['reservationObjectId']!,
            ),
            name: "Show Damage",
          ),
      '/training/all': (_) =>
          CupertinoPage(child: AllTrainingPage(), name: 'All Training'),
      '/training/all/plan': (route) => CupertinoPage(
            child: PlanTrainingPage(queryParams: route.queryParameters),
            name: 'Plan Training',
          ),
      '/training/all/:id': (info) => CupertinoPage(
            child: ShowTrainingPage(
              reservationDocumentId: info.pathParameters['id']!,
            ),
            name: 'Show Training',
          ),
      '/training/all/reservationObject/:reservationObjectId': (route) =>
          CupertinoPage(
            child: ShowReservationObjectPage(
              documentId: route.pathParameters['reservationObjectId']!,
              name: route.queryParameters['name']!,
            ),
            name: 'Show Reservation Object',
          ),
      '/training/all/reservationObject/:reservationObjectId/damage/edit':
          (route) => CupertinoPage(
                child: DamagesEditPage(
                  damageDocumentId: route.queryParameters['id']!,
                  reservationObjectId:
                      route.pathParameters['reservationObjectId']!,
                ),
                name: 'Edit Damage',
              ),
      '/training/all/reservationObject/:reservationObjectId/damage/show':
          (route) => CupertinoPage(
                child: DamagesShowPage(
                  damageDocumentId: route.queryParameters['id']!,
                  reservationObjectId:
                      route.pathParameters['reservationObjectId']!,
                ),
                name: 'Show Damage',
              ),
      '/training/all/reservationObject/:reservationObjectId/damage/create':
          (route) => CupertinoPage(
                child: DamagesCreatePage(
                  reservationObjectId:
                      route.pathParameters['reservationObjectId']!,
                ),
                name: 'Create Damage',
              ),
      '/more': (route) => const CupertinoPage(child: MorePage(), name: 'More'),
      '/more/events': (info) =>
          const CupertinoPage(child: EventsPage(), name: 'More -> Events'),
      '/more/beleid': (info) =>
          const CupertinoPage(child: BeleidPage(), name: 'Beleid'),
      '/more/advanced-settings': (_) => const CupertinoPage(
            child: AdvancedSettingsPage(),
            name: 'Advanced Settings',
          ),
      '/more/gallery': (route) => const CupertinoPage(
            child: GalleryMainPage(),
          ),
      '/contact': (route) =>
          const CupertinoPage(child: ContactPage(), name: 'Contact'),
    },
    onUnknownRoute: (route) => const Redirect('/'),
  );

  static final unauthenticated = RouteMap(
    routes: {
      '/': (_) => const MaterialPage(
            child: LoginPage(),
            name: 'Login',
          ),
      '/forgot': (info) => const CupertinoPage(
            child: ForgotPasswordPage(),
            name: "Forgot Password",
          ),
    },
    onUnknownRoute: (route) => const Redirect('/'),
  );
}
