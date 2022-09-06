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
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i6;

import '../features/announcements/pages/announcement_page.dart' as _i5;
import '../features/announcements/pages/announcements_page.dart' as _i3;
import '../features/dashboard/pages/home_page.dart' as _i2;
import '../features/profiles/pages/almanak_page.dart' as _i4;
import '../main_page.dart' as _i1;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.MainPage());
    },
    HomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.HomePage());
    },
    AnnouncementsRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.AnnouncementsPage());
    },
    AlmanakRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.AlmanakPage());
    },
    AnnouncementRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.AnnouncementPage());
    },
    Container.name: (routeData) {
      final args =
          routeData.argsAs<ContainerArgs>(orElse: () => const ContainerArgs());
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.Container(
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
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(MainRoute.name, path: '/', children: [
          _i7.RouteConfig('#redirect',
              path: '',
              parent: MainRoute.name,
              redirectTo: 'home',
              fullMatch: true),
          _i7.RouteConfig(HomeRoute.name, path: 'home', parent: MainRoute.name),
          _i7.RouteConfig(AnnouncementsRoute.name,
              path: 'announcements',
              parent: MainRoute.name,
              children: [
                _i7.RouteConfig(AnnouncementRoute.name,
                    path: ':announcementId', parent: AnnouncementsRoute.name)
              ]),
          _i7.RouteConfig(AlmanakRoute.name,
              path: 'almanak',
              parent: MainRoute.name,
              children: [
                _i7.RouteConfig(Container.name,
                    path: ':profileId', parent: AlmanakRoute.name)
              ])
        ])
      ];
}

/// generated route for
/// [_i1.MainPage]
class MainRoute extends _i7.PageRouteInfo<void> {
  const MainRoute({List<_i7.PageRouteInfo>? children})
      : super(MainRoute.name, path: '/', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: 'home');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.AnnouncementsPage]
class AnnouncementsRoute extends _i7.PageRouteInfo<void> {
  const AnnouncementsRoute({List<_i7.PageRouteInfo>? children})
      : super(AnnouncementsRoute.name,
            path: 'announcements', initialChildren: children);

  static const String name = 'AnnouncementsRoute';
}

/// generated route for
/// [_i4.AlmanakPage]
class AlmanakRoute extends _i7.PageRouteInfo<void> {
  const AlmanakRoute({List<_i7.PageRouteInfo>? children})
      : super(AlmanakRoute.name, path: 'almanak', initialChildren: children);

  static const String name = 'AlmanakRoute';
}

/// generated route for
/// [_i5.AnnouncementPage]
class AnnouncementRoute extends _i7.PageRouteInfo<void> {
  const AnnouncementRoute()
      : super(AnnouncementRoute.name, path: ':announcementId');

  static const String name = 'AnnouncementRoute';
}

/// generated route for
/// [_i6.Container]
class Container extends _i7.PageRouteInfo<ContainerArgs> {
  Container(
      {_i6.Key? key,
      _i6.AlignmentGeometry? alignment,
      _i6.EdgeInsetsGeometry? padding,
      _i6.Color? color,
      _i6.Decoration? decoration,
      _i6.Decoration? foregroundDecoration,
      double? width,
      double? height,
      _i6.BoxConstraints? constraints,
      _i6.EdgeInsetsGeometry? margin,
      _i6.Matrix4? transform,
      _i6.AlignmentGeometry? transformAlignment,
      _i6.Widget? child,
      _i6.Clip clipBehavior = _i6.Clip.none})
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
      this.clipBehavior = _i6.Clip.none});

  final _i6.Key? key;

  final _i6.AlignmentGeometry? alignment;

  final _i6.EdgeInsetsGeometry? padding;

  final _i6.Color? color;

  final _i6.Decoration? decoration;

  final _i6.Decoration? foregroundDecoration;

  final double? width;

  final double? height;

  final _i6.BoxConstraints? constraints;

  final _i6.EdgeInsetsGeometry? margin;

  final _i6.Matrix4? transform;

  final _i6.AlignmentGeometry? transformAlignment;

  final _i6.Widget? child;

  final _i6.Clip clipBehavior;

  @override
  String toString() {
    return 'ContainerArgs{key: $key, alignment: $alignment, padding: $padding, color: $color, decoration: $decoration, foregroundDecoration: $foregroundDecoration, width: $width, height: $height, constraints: $constraints, margin: $margin, transform: $transform, transformAlignment: $transformAlignment, child: $child, clipBehavior: $clipBehavior}';
  }
}
