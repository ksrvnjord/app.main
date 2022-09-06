// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../features/announcements/pages/announcements_page.dart' as _i2;
import '../features/authentication/pages/login_page.dart' as _i4;
import '../features/dashboard/pages/home_page.dart' as _i1;
import '../features/profiles/pages/almanak_page.dart' as _i3;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.HomePage());
    },
    AnnouncementsRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.AnnouncementsPage());
    },
    AlmanakRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.AlmanakPage());
    },
    LoginRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.LoginPage());
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(HomeRoute.name, path: '/'),
        _i5.RouteConfig(AnnouncementsRoute.name, path: '/announcements'),
        _i5.RouteConfig(AlmanakRoute.name, path: '/almanak'),
        _i5.RouteConfig(LoginRoute.name, path: '/login')
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '/');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.AnnouncementsPage]
class AnnouncementsRoute extends _i5.PageRouteInfo<void> {
  const AnnouncementsRoute()
      : super(AnnouncementsRoute.name, path: '/announcements');

  static const String name = 'AnnouncementsRoute';
}

/// generated route for
/// [_i3.AlmanakPage]
class AlmanakRoute extends _i5.PageRouteInfo<void> {
  const AlmanakRoute() : super(AlmanakRoute.name, path: '/almanak');

  static const String name = 'AlmanakRoute';
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/login');

  static const String name = 'LoginRoute';
}
