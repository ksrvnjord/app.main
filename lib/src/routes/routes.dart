import 'package:auto_route/annotations.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcements_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute(path: '/', page: HomePage, initial: true),
  AutoRoute(path: '/announcements', page: AnnouncementsPage),
  AutoRoute(path: '/almanak', page: AlmanakPage),
  AutoRoute(path: '/login', page: LoginPage)
])
class $AppRouter {}
