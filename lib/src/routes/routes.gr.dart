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
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i7;

import '../features/announcements/pages/announcement_page.dart' as _i6;
import '../features/announcements/pages/announcements_page.dart' as _i4;
import '../features/authentication/pages/login_page.dart' as _i2;
import '../features/dashboard/pages/home_page.dart' as _i3;
import '../features/profiles/pages/almanak_page.dart' as _i5;
import '../main_page.dart' as _i1;
import 'guards.dart' as _i9;

class AppRouter extends _i8.RootStackRouter {
  AppRouter(
      {_i7.GlobalKey<_i7.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i9.AuthGuard authGuard;

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.WrappedRoute(child: const _i1.MainPage()));
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i2.LoginPage(key: args.key, loginCallback: args.loginCallback));
    },
    HomeRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.HomePage());
    },
    AnnouncementsRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.AnnouncementsPage());
    },
    AlmanakRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.AlmanakPage());
    },
    AnnouncementRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.AnnouncementPage());
    },
    Container.name: (routeData) {
      final args =
          routeData.argsAs<ContainerArgs>(orElse: () => const ContainerArgs());
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.Container(
              key: args.key,
              alignment: args.alignment,
              padding: args.padding,
              color: args.color,
              decoration: args.decoration,
              foregroundDecoration: args.foregroundDecoration,
              width: args.width,
              height: args.height,
              constraints: args.constraints,
              margin: args.margin,
              transform: args.transform,
              transformAlignment: args.transformAlignment,
              child: args.child,
              clipBehavior: args.clipBehavior));
    }
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(MainRoute.name, path: '/', guards: [
          authGuard
        ], children: [
          _i8.RouteConfig('#redirect',
              path: '',
              parent: MainRoute.name,
              redirectTo: 'home',
              fullMatch: true),
          _i8.RouteConfig(HomeRoute.name, path: 'home', parent: MainRoute.name),
          _i8.RouteConfig(AnnouncementsRoute.name,
              path: 'announcements',
              parent: MainRoute.name,
              children: [
                _i8.RouteConfig(AnnouncementRoute.name,
                    path: ':announcementId', parent: AnnouncementsRoute.name)
              ]),
          _i8.RouteConfig(AlmanakRoute.name,
              path: 'almanak',
              parent: MainRoute.name,
              children: [
                _i8.RouteConfig(Container.name,
                    path: ':profileId', parent: AlmanakRoute.name)
              ])
        ]),
        _i8.RouteConfig(LoginRoute.name, path: '/login')
      ];
}

/// generated route for
/// [_i1.MainPage]
class MainRoute extends _i8.PageRouteInfo<void> {
  const MainRoute({List<_i8.PageRouteInfo>? children})
      : super(MainRoute.name, path: '/', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i7.Key? key, required void Function(bool) loginCallback})
      : super(LoginRoute.name,
            path: '/login',
            args: LoginRouteArgs(key: key, loginCallback: loginCallback));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, required this.loginCallback});

  final _i7.Key? key;

  final void Function(bool) loginCallback;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, loginCallback: $loginCallback}';
  }
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: 'home');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.AnnouncementsPage]
class AnnouncementsRoute extends _i8.PageRouteInfo<void> {
  const AnnouncementsRoute({List<_i8.PageRouteInfo>? children})
      : super(AnnouncementsRoute.name,
            path: 'announcements', initialChildren: children);

  static const String name = 'AnnouncementsRoute';
}

/// generated route for
/// [_i5.AlmanakPage]
class AlmanakRoute extends _i8.PageRouteInfo<void> {
  const AlmanakRoute({List<_i8.PageRouteInfo>? children})
      : super(AlmanakRoute.name, path: 'almanak', initialChildren: children);

  static const String name = 'AlmanakRoute';
}

/// generated route for
/// [_i6.AnnouncementPage]
class AnnouncementRoute extends _i8.PageRouteInfo<void> {
  const AnnouncementRoute()
      : super(AnnouncementRoute.name, path: ':announcementId');

  static const String name = 'AnnouncementRoute';
}

/// generated route for
/// [_i7.Container]
class Container extends _i8.PageRouteInfo<ContainerArgs> {
  Container(
      {_i7.Key? key,
      _i7.AlignmentGeometry? alignment,
      _i7.EdgeInsetsGeometry? padding,
      _i7.Color? color,
      _i7.Decoration? decoration,
      _i7.Decoration? foregroundDecoration,
      double? width,
      double? height,
      _i7.BoxConstraints? constraints,
      _i7.EdgeInsetsGeometry? margin,
      _i7.Matrix4? transform,
      _i7.AlignmentGeometry? transformAlignment,
      _i7.Widget? child,
      _i7.Clip clipBehavior = _i7.Clip.none})
      : super(Container.name,
            path: ':profileId',
            args: ContainerArgs(
                key: key,
                alignment: alignment,
                padding: padding,
                color: color,
                decoration: decoration,
                foregroundDecoration: foregroundDecoration,
                width: width,
                height: height,
                constraints: constraints,
                margin: margin,
                transform: transform,
                transformAlignment: transformAlignment,
                child: child,
                clipBehavior: clipBehavior));

  static const String name = 'Container';
}

class ContainerArgs {
  const ContainerArgs(
      {this.key,
      this.alignment,
      this.padding,
      this.color,
      this.decoration,
      this.foregroundDecoration,
      this.width,
      this.height,
      this.constraints,
      this.margin,
      this.transform,
      this.transformAlignment,
      this.child,
      this.clipBehavior = _i7.Clip.none});

  final _i7.Key? key;

  final _i7.AlignmentGeometry? alignment;

  final _i7.EdgeInsetsGeometry? padding;

  final _i7.Color? color;

  final _i7.Decoration? decoration;

  final _i7.Decoration? foregroundDecoration;

  final double? width;

  final double? height;

  final _i7.BoxConstraints? constraints;

  final _i7.EdgeInsetsGeometry? margin;

  final _i7.Matrix4? transform;

  final _i7.AlignmentGeometry? transformAlignment;

  final _i7.Widget? child;

  final _i7.Clip clipBehavior;

  @override
  String toString() {
    return 'ContainerArgs{key: $key, alignment: $alignment, padding: $padding, color: $color, decoration: $decoration, foregroundDecoration: $foregroundDecoration, width: $width, height: $height, constraints: $constraints, margin: $margin, transform: $transform, transformAlignment: $transformAlignment, child: $child, clipBehavior: $clipBehavior}';
  }
}
