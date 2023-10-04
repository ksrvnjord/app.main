// ignore_for_file: prefer-match-file-name
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/documents/pages/documents_main_page.dart';
import 'package:ksrvnjord_main_app/src/features/posts/pages/comments_page.dart';
import 'package:ksrvnjord_main_app/src/features/posts/pages/create_post_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_edit_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_list_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_show_page.dart';
import 'package:ksrvnjord_main_app/src/features/damages/pages/damages_create_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/events/pages/events_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/advanced_settings_page.dart';
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
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/my_permissions_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/select_ploeg_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/pages/settings_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/leeden/pages/almanak_leeden_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/almanak_profile_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/huis_choice_page.dart';
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
import 'package:ksrvnjord_main_app/src/features/shared/model/global_observer_service.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/all_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/plan_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_reservation_object_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/training_page.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_main_page.dart';
import 'package:ksrvnjord_main_app/src/main_page.dart';
import 'package:ksrvnjord_main_app/src/routes/dutch_upgrade_messages.dart';
import 'package:ksrvnjord_main_app/src/routes/unknown_route_page.dart';
import 'package:routemaster/routemaster.dart';
import 'package:upgrader/upgrader.dart';

@immutable
class Routes {
  static const List<String> mainRoutes = [
    '/home',
    '/posts',
    '/training',
    '/almanak',
    '/more',
  ];

  static final authenticated = RouteMap(
    routes: {
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
      '/almanak/commissies': (_) => const CupertinoPage(
            child: CommissieChoicePage(),
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
            child: HuisChoicePage(title: "Huizen", choices: houseNames),
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
      '/more': (route) => const CupertinoPage(child: MorePage(), name: 'More'),
      '/more/events': (info) =>
          const CupertinoPage(child: EventsPage(), name: 'More -> Events'),
      '/more/gallery': (route) => const CupertinoPage(
            child: GalleryMainPage(),
          ),
      '/more/documents': (route) => const CupertinoPage(
            child: DocumentsMainPage(),
          ),
      '/more/contact': (route) =>
          const CupertinoPage(child: ContactPage(), name: 'Contact'),
    },
    onUnknownRoute: (route) => const CupertinoPage(child: UnknownRoutePage()),
  );

  static final unauthenticated = [
    GoRoute(
      path: '/login',
      name: 'Login',
      pageBuilder: (child, state) =>
          getPage(child: const LoginPage(), name: "Login"),
    ),
    GoRoute(
      path: '/forgot',
      name: 'Forgot Password',
      pageBuilder: (child, state) =>
          getPage(child: const ForgotPasswordPage(), name: "Forgot Password"),
    ),
  ];

  static final homeRoutes = [
    route(
      path: '/',
      name: "Home",
      child: UpgradeAlert(
        upgrader: Upgrader(
          messages: DutchUpgradeMessages(),
          countryCode: 'nl',
          languageCode: 'nl',
        ),
        child: const HomePage(),
      ),
      routes: [
        // Route for viewing all forms.
        route(
          path: 'polls',
          name: "Polls",
          child: const PollsPage(),
        ),
        // Route for viewing all events.
        route(
          path: 'events',
          name: "Events",
          child: const EventsPage(),
        ),
        // Dynamic route for viewing one announcement.
        route(
          path: 'announcements/:id',
          name: "Announcement",
          pageBuilder: (context, state) => getPage(
            child: AnnouncementPage(
              announcementId: state.pathParameters['id']!,
            ),
            name: "Announcement",
          ),
        ),
        route(
          path: 'my-profile',
          name: "Edit Profile",
          child: const EditAlmanakProfilePage(),
          routes: [
            route(
              path: 'public-profile/:identifier',
              name: "Preview Profile",
              pageBuilder: (context, state) => getPage(
                child: AlmanakProfilePage(
                  userId: state.pathParameters['identifier']!,
                ),
                name: "Preview Profile",
              ),
            ),
            route(
              path: 'sensitive-data',
              name: "Sensitive Data",
              child: const MePage(),
            ),
            route(
              path: 'permissions',
              name: "My Permissions",
              child: const MyPermissionsPage(),
            ),
            // route for my allergies page
            route(
              path: 'allergies',
              name: "My Allergies",
              child: const EditAllergiesPage(),
            ),
            route(
                path: 'groups',
                name: "My Groups",
                child: const EditGroupsPage(),
                routes: [
                  route(
                    path: 'ploeg',
                    name: "Select Ploeg",
                    child: const SelectPloegPage(),
                    routes: [
                      route(
                        path: 'add',
                        name: "Add Ploeg",
                        child: const AddPloegPage(),
                      ),
                    ],
                  )
                ]),
            route(
              path: 'commissies',
              name: "My Commissies",
              child: const EditCommissiesPage(),
              routes: [
                route(
                  path: 'select',
                  name: "Select Commissie",
                  child: const SelectCommissiePage(),
                  routes: [
                    route(
                      path: 'fill-info',
                      name: "Fill Commissie Info",
                      pageBuilder: (context, state) => getPage(
                        child: FillCommissieInfoPage(
                          commissie: state.uri.queryParameters['commissie']!,
                        ),
                        name: "Fill Commissie Info",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            route(
              path: 'settings',
              name: "Settings",
              child: const SettingsPage(),
              routes: [
                route(
                  path: 'advanced',
                  name: "Advanced Settings",
                  child: const AdvancedSettingsPage(),
                ),
                route(
                  path: 'notification-preferences',
                  name: "Notification Preferences",
                  child: const NotificationsPage(),
                ),
                route(
                  path: 'visibility',
                  name: "Edit my visibility",
                  child: const MePrivacyPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static final postsRoutes = [
    route(path: '/posts', name: 'Posts', child: const PostsPage(), routes: [
      route(
        path: 'new',
        name: 'New Post',
        child: const CreatePostPage(),
      ),
      route(
        path: ':postId/comments',
        name: 'Post -> Comments',
        pageBuilder: (context, state) => getPage(
          child: CommentsPage(
            postDocId: state.pathParameters['postId']!,
          ),
          name: "Post -> Comments",
        ),
      ),
    ]),
  ];

  static final reservationRoutes = [
    route(
      path: "/training",
      name: "Training",
      child: const TrainingPage(),
      routes: [
        // route for viewing all damages
        route(
          path: 'damages',
          name: "Damages",
          child: const DamagesListPage(),
          routes: [
            route(
              path: 'create',
              name: "Create Damage",
              child: const DamagesCreatePage(),
            ),
            route(
              path: 'edit',
              name: "Edit Damage",
              pageBuilder: (context, state) => getPage(
                child: DamagesEditPage(
                  damageDocumentId: state.uri.queryParameters['id']!,
                  reservationObjectId:
                      state.uri.queryParameters['reservationObjectId']!,
                ),
                name: "Edit Damage",
              ),
            ),
            route(
              path: 'show',
              name: "Show Damage",
              pageBuilder: (context, state) => getPage(
                child: DamagesShowPage(
                  damageDocumentId: state.uri.queryParameters['id']!,
                  reservationObjectId:
                      state.uri.queryParameters['reservationObjectId']!,
                ),
                name: "Show Damage",
              ),
            ),
          ],
        ),
        // route for view all training
        route(
          path: 'all',
          name: "Planning Overview",
          child: const AllTrainingPage(),
          routes: [
            route(
              path: 'plan',
              name: "Plan Training",
              pageBuilder: (context, state) => getPage(
                child: PlanTrainingPage(
                  queryParams: state.uri.queryParameters,
                ),
                name: "Plan Training",
              ),
            ),
            route(
              path: ':id',
              name: "Show Training",
              pageBuilder: (context, state) => getPage(
                child: ShowTrainingPage(
                  reservationDocumentId: state.pathParameters['id']!,
                ),
                name: "Show Training",
              ),
            ),
            route(
              path: 'reservationObject/:id',
              name: "Show Reservation Object",
              pageBuilder: (context, state) => getPage(
                child: ShowReservationObjectPage(
                  documentId: state.pathParameters['id']!,
                  name: state.uri.queryParameters['name']!,
                ),
                name: "Show Reservation Object",
              ),
              routes: [],
            ),
          ],
        ),
      ],
    ),
  ];

  static final almanakRoutes = [
    // route for almanak
    route(
      path: "/almanak",
      name: "Almanak",
      child: const AlmanakPage(),
    ),
  ];

  static final moreRoutes = [
    route(
      path: "/more",
      name: "More",
      child: const MorePage(),
    )
  ];
}

// This is super important - otherwise, we would throw away the whole widget tree when the provider is updated.
// ignore: prefer-static-class
final _navigatorKey = GlobalKey<NavigatorState>();
// We need to have access to the previous location of the router. Otherwise, we would start from '/' on rebuild.
// ignore: prefer-static-class
GoRouter? _previousRouter;

// ignore: prefer-static-class
final routerProvider = Provider((ref) {
  final auth = ref.watch(authModelProvider);
  final loggedIn = auth.client != null;

  return GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
            branches: [
              StatefulShellBranch(routes: Routes.homeRoutes),
              StatefulShellBranch(routes: Routes.postsRoutes),
              StatefulShellBranch(routes: Routes.reservationRoutes),
              StatefulShellBranch(routes: Routes.almanakRoutes),
              StatefulShellBranch(routes: Routes.moreRoutes),
            ],
            pageBuilder: (context, state, navigationShell) => getPage(
                child: MainPage(navigationShell: navigationShell),
                name: "Bottom Navigation Bar")),
        ...Routes.unauthenticated
      ],
      redirect: (context, state) {
        final bool loggingIn = state.matchedLocation == '/login';
        if (!loggedIn) {
          return loggingIn ? null : '/login';
        }
        if (loggingIn) {
          return '/';
        }
        return null;
      },
      initialLocation: _previousRouter?.routeInformationProvider.value.location,
      observers: [
        GlobalObserver(),
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
      ],
      debugLogDiagnostics: true,
      navigatorKey: _navigatorKey);
});

// ignore: prefer-static-class
Page getPage({
  required Widget child,
  required String
      name, // Used so we can view the page name in Firebase Analytics.
}) {
  return CupertinoPage(child: child, name: name);
}

/// Creates a new [GoRoute] instance with the specified parameters.
///
/// The [path] parameter is a required string that represents the path of the route.
///
/// The [name] parameter is a required string that represents the name of the route.
///
/// The [child] parameter is an optional [Widget] that represents the child of the route.
///
/// The [routes] parameter is an optional list of [RouteBase] objects that represent the sub-routes of the route.
///
/// The [pageBuilder] parameter is an optional function that takes a [BuildContext] and a [GoRouterState] and returns a [Page] object. If this parameter is not specified, a default page builder will be used that creates a page with the specified [child] and [name].
///
/// Throws an [ArgumentError] if neither [child] nor [pageBuilder] is specified, or if both are specified.
///
/// Returns a new [GoRoute] instance with the specified parameters.
// ignore: prefer-static-class
GoRoute route({
  required String path,
  required String name,
  Widget? child,
  List<RouteBase>? routes,
  Page Function(BuildContext, GoRouterState)? pageBuilder,
}) {
  if (child == null && pageBuilder == null) {
    throw ArgumentError(
      "You must specify either a child or a pageBuilder for a route.",
    );
  }

  if (child != null && pageBuilder != null) {
    throw ArgumentError(
      "You can't specify both a child and a pageBuilder for a route.",
    );
  }

  return GoRoute(
    path: path,
    name: name,
    pageBuilder:
        pageBuilder ?? (context, state) => getPage(child: child!, name: name),
    routes: routes ?? [],
  );
}
