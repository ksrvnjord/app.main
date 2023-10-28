// ignore_for_file: prefer-match-file-name
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/pages/admin_page.dart';
import 'package:ksrvnjord_main_app/src/features/admin/push_notifications/create_push_notification_page.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_state.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/forgot_password_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/documents/pages/documents_main_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/about_this_app_page.dart';
import 'package:ksrvnjord_main_app/src/features/polls/pages/poll_page.dart';
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
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
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
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/all_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/plan_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_reservation_object_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_training_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/training_page.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_main_page.dart';
import 'package:ksrvnjord_main_app/src/main_page.dart';
import 'package:ksrvnjord_main_app/src/routes/dutch_upgrade_messages.dart';
import 'package:ksrvnjord_main_app/src/routes/unauthorized_route_page.dart';
import 'package:ksrvnjord_main_app/src/routes/unknown_route_page.dart';
import 'package:upgrader/upgrader.dart';

@immutable
class RouteName {
  static const forms = "Forms";
  static const postComments = "Post -> Comments";
  static const editMyVisibility = "Edit my visibility";
  static const reservation = "Reservation";
}

// This is super important - otherwise, we would throw away the whole widget tree when the provider is updated.
// ignore: prefer-static-class
final _navigatorKey = GlobalKey<NavigatorState>();
// We need to have access to the previous location of the router. Otherwise, we would start from '/' on rebuild.
// ignore: prefer-static-class
GoRouter? _previousRouter;

class Routes {
  // We use a Provider for the routerconfiguration so we can access the Authentication State and redirect to the login page if the user is not logged in.
  // ignore: prefer-static-class
  static final routerProvider = Provider((ref) {
    return GoRouter(
      routes: [
        // The StatefulShell approach enables us to have a bottom navigation bar that is persistent across all pages and have stateful navigation.
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(routes: Routes._homeRoutes),
            StatefulShellBranch(routes: Routes._postsRoutes),
            StatefulShellBranch(routes: Routes._reservationRoutes),
            StatefulShellBranch(routes: Routes._almanakRoutes),
            StatefulShellBranch(routes: Routes._moreRoutes),
          ],
          pageBuilder: (context, state, navigationShell) => _getPage(
            child: MainPage(navigationShell: navigationShell),
            name: "Bottom Navigation Bar",
          ),
        ),
        ...Routes._unauthenticated,
        ...Routes._adminRoutes,
        _route(
          name: "Unknown Route",
          path: '/404',
          child: const UnknownRoutePage(),
        ),
        _route(
          name: "Unauthorized Route",
          path: '/401',
          child: const UnauthorizedRoutePage(),
        ),
      ],
      errorPageBuilder: (context, state) => _getPage(
        child: const UnknownRoutePage(),
        name: "Unknown Route",
      ),
      redirect: (context, state) {
        final AuthState authState = ref.read(authModelProvider).authState;
        const String loginPath = '/login';
        const String initialLocation = '/';
        final currentPath = state.uri.path;

        final loginPathWithRedirect = Uri(
          path: loginPath,
          queryParameters: initialLocation == currentPath
              ? {}
              : {'from': state.uri.toString()},
        ).toString();

        switch (authState) {
          case AuthState.loading:
            if (currentPath != loginPath) {
              // Loading happens on login page, as login page shows the loading widget.
              return loginPathWithRedirect;
            }
            break;
          case AuthState.unauthenticated:
            final routeRequiresAuth = !Routes._unauthenticated
                .any((route) => route.path == currentPath);
            if (routeRequiresAuth) {
              return loginPathWithRedirect;
            }
            break;
          case AuthState.authenticated:
            if (currentPath == loginPath) {
              return state.uri.queryParameters['from'] ?? initialLocation;
            }
            final bool currentRouteRequiresAdmin =
                Routes._adminRoutes.any((route) => route.path == currentPath);
            final bool userIsAdmin = ref.watch(currentFirestoreUserProvider
                    .select((value) => value?.isAdmin)) ??
                false; // Watch for changes in the user's admin status.
            if (currentRouteRequiresAdmin && !userIsAdmin) {
              return '/401';
            }

            break;
          default:
            throw UnimplementedError("Unknown AuthState");
        }

        return null;
      },
      refreshListenable: ref.read(authModelProvider),
      initialLocation:
          _previousRouter?.routeInformationProvider.value.uri.path ?? '/',
      observers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      debugLogDiagnostics: true,
      navigatorKey: _navigatorKey,
    );
  });

  static final _homeRoutes = [
    _route(
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
        _route(
          path: 'forms', // Used for Deeplinking-pilot, so don't change this.
          name: RouteName.forms,
          child: const PollsPage(),
          routes: [
            // Dynamic route for viewing one form.
            // At the moment only accessible through deeplink, not in App-UI.
            _route(
              path: ':formId',
              name: "Form",
              pageBuilder: (context, state) => _getPage(
                child: PollPage(pollId: state.pathParameters['formId']!),
                name: "Form",
              ),
            ),
          ],
        ),
        // Route for viewing all events.
        _route(
          path: 'evenementen',
          name: "Events",
          child: const EventsPage(),
        ),
        // Dynamic route for viewing one announcement.
        _route(
          path: 'aankondigingen/:id',
          name: "Announcement",
          pageBuilder: (context, state) => _getPage(
            child: AnnouncementPage(
              announcementId: state.pathParameters['id']!,
            ),
            name: "Announcement",
          ),
        ),
        _route(
          path: 'mijn-profiel',
          name: "Edit Profile",
          child: const EditAlmanakProfilePage(),
          routes: [
            _route(
              path: 'publiek-profiel/:identifier',
              name: "Preview Profile",
              pageBuilder: (context, state) => _getPage(
                child: AlmanakProfilePage(
                  userId: state.pathParameters['identifier']!,
                ),
                name: "Preview Profile",
              ),
            ),
            _route(
              path: 'gevoelige-data',
              name: "Sensitive Data",
              child: const MePage(),
            ),
            _route(
              path: 'permissies',
              name: "My Permissions",
              child: const MyPermissionsPage(),
            ),
            // Route for my allergies page.
            _route(
              path: 'allergieen',
              name: "My Allergies",
              child: const EditAllergiesPage(),
            ),
            _route(
              path: 'groepen',
              name: "My Groups",
              child: const EditGroupsPage(),
              routes: [
                GoRoute(
                  path: 'ploeg',
                  name: "Select Ploeg",
                  pageBuilder: (context, state) => _getPage(
                    child: SelectPloegPage(
                      selectedYear: int.parse(
                        state.uri.queryParameters['year']!,
                      ),
                    ),
                    name: "Select Ploeg",
                  ),
                  redirect: (
                    context,
                    state,
                  ) => // Default route is ploegen for currentYear.
                      state.uri.queryParameters['year'] == null
                          ? Uri(
                              path: state.matchedLocation,
                              queryParameters: {
                                'year': getNjordYear().toString(),
                              },
                            ).toString()
                          : null,
                  routes: [
                    _route(
                      path: 'toevoegen',
                      name: "Add Ploeg",
                      child: const AddPloegPage(),
                    ),
                  ],
                ),
              ],
            ),
            _route(
              path: 'commissies',
              name: "My Commissies",
              child: const EditCommissiesPage(),
              routes: [
                _route(
                  path: 'selecteer',
                  name: "Select Commissie",
                  child: const SelectCommissiePage(),
                  routes: [
                    _route(
                      path: 'vul-info',
                      name: "Fill Commissie Info",
                      pageBuilder: (context, state) => _getPage(
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
            _route(
              path: 'instellingen',
              name: "Settings",
              child: const SettingsPage(),
              routes: [
                _route(
                  path: 'geavanceerd',
                  name: "Advanced Settings",
                  child: const AdvancedSettingsPage(),
                ),
                _route(
                  path: 'notificatie-voorkeuren',
                  name: "Notification Preferences",
                  child: const NotificationsPage(),
                ),
                _route(
                  path: 'zichtbaarheid',
                  name: RouteName.editMyVisibility,
                  child: const MePrivacyPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static final _postsRoutes = [
    _route(
      path: '/prikbord',
      name: 'Posts',
      child: const PostsPage(),
      routes: [
        _route(
          path: 'nieuw',
          name: 'New Post',
          child: const CreatePostPage(),
        ),
        _route(
          path: ':id/comments',
          name: RouteName.postComments,
          pageBuilder: (context, state) => _getPage(
            child: CommentsPage(
              postDocId: state.pathParameters['id']!,
            ),
            name: RouteName.postComments,
          ),
        ),
      ],
    ),
  ];

  static final _reservationRoutes = [
    _route(
      path: "/afschrijven",
      name: "Training",
      child: const TrainingPage(),
      routes: [
        // Route for viewing all damages.
        _route(
          path: 'schademeldingen',
          name: "Damages",
          child: const DamagesListPage(),
          routes: [
            _route(
              path: 'melden',
              name: "Create Damage",
              child: const DamagesCreatePage(),
            ),
            _route(
              path: 'aanpassen',
              name: "Edit Damage",
              pageBuilder: (context, state) => _getPage(
                child: DamagesEditPage(
                  damageDocumentId: state.uri.queryParameters['id']!,
                  reservationObjectId:
                      state.uri.queryParameters['reservationObjectId']!,
                ),
                name: "Edit Damage",
              ),
            ),
            _route(
              path: 'bekijken',
              name: "Show Damage",
              pageBuilder: (context, state) => _getPage(
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
        // Route for view all training.
        _route(
          path: 'mijn-afschrijvingen',
          name: "Planning Overview",
          child: const AllTrainingPage(),
          routes: [
            _route(
              path: 'nieuw',
              name: "Plan Training",
              pageBuilder: (context, state) => _getPage(
                child: PlanTrainingPage(
                  queryParams: state.uri.queryParameters,
                ),
                name: "Plan Training",
              ),
            ),
            _route(
              path: ':id',
              name: RouteName.reservation,
              pageBuilder: (context, state) => _getPage(
                child: ShowTrainingPage(
                  reservationDocumentId: state.pathParameters['id']!,
                ),
                name: RouteName.reservation,
              ),
            ),
            _route(
              path: 'afschrijvingObject/:id',
              name: "Show Reservation Object",
              pageBuilder: (context, state) => _getPage(
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

  static final _almanakRoutes = [
    // Route for almanak.
    _route(
      path: "/almanak",
      name: "Almanak",
      child: const AlmanakPage(),
      routes: [
        _route(
          path: "leeden",
          name: "Leeden",
          child: const AlmanakLeedenPage(),
        ),
        _route(
          path: "bestuur",
          name: "Bestuur",
          child: const AlmanakBestuurPage(),
        ),
        _route(
          path: "commissies",
          name: "Commissies",
          child: const CommissieChoicePage(),
          routes: [
            _route(
              path: ":name",
              name: "Commissie",
              pageBuilder: (context, state) => _getPage(
                child: AlmanakCommissiePage(
                  commissieName: state.pathParameters['name']!,
                  commissieYear: state.uri.queryParameters['year'] != null
                      ? int.parse(state.uri.queryParameters['year']!)
                      : null,
                ),
                name: "Commissie",
              ),
            ),
          ],
        ),
        GoRoute(
          path: "ploegen",
          name: "Ploegen",
          pageBuilder: (context, state) => _getPage(
            child: PloegChoicePage(
              ploegYear: state.uri.queryParameters['year'] == null
                  ? getNjordYear()
                  : int.parse(state.uri.queryParameters['year']!),
            ),
            name: "Ploegen",
          ),
          redirect:
              (context, state) => // Default route is ploegen for currentYear.
                  state.uri.queryParameters['year'] == null
                      ? Uri(
                          path: state.matchedLocation,
                          queryParameters: {'year': getNjordYear().toString()},
                        ).toString()
                      : null,
          routes: [
            _route(
              path: ":ploeg",
              name: "Ploeg",
              pageBuilder: (context, state) => _getPage(
                child: AlmanakPloegPage(
                  ploegName: state.pathParameters['ploeg']!,
                  year: state.uri.queryParameters['year'] == null
                      ? getNjordYear()
                      : int.parse(state.uri.queryParameters['year']!),
                ),
                name: "Ploeg",
              ),
            ),
          ],
        ),
        _route(
          path: "huizen",
          name: "Huizen",
          child: const HuisChoicePage(title: "Huizen", choices: houseNames),
          routes: [
            _route(
              path: ":name",
              name: "Huis",
              pageBuilder: (context, state) => _getPage(
                child: AlmanakHuisPage(
                  houseName: state.pathParameters['name']!,
                ),
                name: "Huis",
              ),
            ),
          ],
        ),
        _route(
          path: "substructuren",
          name: "Substructuren",
          child: SubstructureChoicePage(
            title: "Substructuren",
            choices: substructures.toList(),
          ),
          routes: [
            _route(
              path: ":name",
              name: "Substructuur",
              pageBuilder: (context, state) => _getPage(
                child: AlmanakSubstructuurPage(
                  name: state.pathParameters['name']!,
                ),
                name: "Substructuur",
              ),
            ),
          ],
        ),
      ],
    ),
    _route(
      path: "/lid/:id",
      name: "Lid",
      pageBuilder: (context, state) => _getPage(
        child: AlmanakProfilePage(userId: state.pathParameters['id']!),
        name: "Lid",
      ),
    ),
  ];

  static final _moreRoutes = [
    _route(
      path: "/meer",
      name: "More",
      child: const MorePage(),
      routes: [
        // Route for about page.
        _route(
          path: "about",
          name: "About this app",
          child: const AboutThisAppPage(),
        ),
        // Route for GalleryPage.
        _route(
          path: "gallerij",
          name: "Gallery",
          child: const GalleryMainPage(),
        ),
        // Route for DocumentsPage.
        _route(
          path: "documenten",
          name: "Documents",
          child: const DocumentsMainPage(),
        ),
        // Route for contact page.
        _route(
          path: "contact",
          name: "Contact",
          child: const ContactPage(),
        ),
      ],
    ),
  ];

  static final _adminRoutes = [
    _route(
      path: "/admin",
      name: "Admin",
      child: const AdminPage(),
      routes: [
        _route(
          path: "maak-push-notificatie",
          name: "Create Push Notification",
          pageBuilder: (context, state) => _getPage(
            child: CreatePushNotificationPage(),
            name: "Create Push Notification",
          ),
        ),
      ],
    ),
  ];

  static final _unauthenticated = [
    GoRoute(
      path: '/login',
      name: 'Login',
      pageBuilder: (child, state) =>
          _getPage(child: const LoginPage(), name: "Login"),
    ),
    GoRoute(
      path: '/wachtwoord-vergeten',
      name: 'Forgot Password',
      pageBuilder: (child, state) =>
          _getPage(child: const ForgotPasswordPage(), name: "Forgot Password"),
    ),
  ];

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
  static GoRoute _route({
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
      pageBuilder: pageBuilder ??
          // ignore: avoid-non-null-assertion
          (context, state) => _getPage(child: child!, name: name),
      routes: routes ?? [],
    );
  }

  /// A Wrapper for all app pages into a CupertinoPage.
  ///
  /// The [name] parameter is used to view the page name in Firebase Analytics.
  ///
  static Page _getPage({
    required Widget child,
    required String
        name, // Used so we can view the page name in Firebase Analytics.
  }) {
    return CupertinoPage(child: child, name: name);
  }
}
