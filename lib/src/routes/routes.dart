import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcement_page.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcements_page.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_page.dart';
import 'package:ksrvnjord_main_app/src/main_page.dart';
import 'package:ksrvnjord_main_app/src/routes/guards.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute(
    path: '/',
    page: MainPage,
    guards: [AuthGuard],
    children: <AutoRoute>[
      AutoRoute(path: 'home', page: HomePage, initial: true),
      AutoRoute(
          path: 'announcements',
          page: AnnouncementsPage,
          children: <AutoRoute>[
            AutoRoute(path: ':announcementId', page: AnnouncementPage)
          ]),
      AutoRoute(path: 'almanak', page: AlmanakPage, children: <AutoRoute>[
        AutoRoute(path: ':profileId', page: Container)
      ]),
    ],
  ),
  AutoRoute(page: LoginPage, path: '/login')
])
class $AppRouter {}
