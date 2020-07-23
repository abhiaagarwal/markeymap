// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'pages/map_page.dart';

class Routes {
  static const String mapPage = '/';
  static const all = <String>{
    mapPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.mapPage, page: MapPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    MapPage: (data) {
      return PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MapPage(),
        settings: data,
      );
    },
  };
}
