// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:markeymap/pages/map_page.dart';
import 'package:markeymap/pages/town_list_page.dart';

class Routes {
  static const String mapPage = '/map';
  static const String _townListPage = '/county/:county';
  static townListPage({@required county}) => '/county/$county';
  static const all = <String>{
    mapPage,
    _townListPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.mapPage, page: MapPage),
    RouteDef(Routes._townListPage, page: TownListPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    MapPage: (RouteData data) {
      var args =
          data.getArgs<MapPageArguments>(orElse: () => MapPageArguments());
      return PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MapPage(key: args.key),
        settings: data,
      );
    },
    TownListPage: (RouteData data) {
      var args = data.getArgs<TownListPageArguments>(
          orElse: () => TownListPageArguments());
      return PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TownListPage(key: args.key),
        settings: data,
      );
    },
  };
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//MapPage arguments holder class
class MapPageArguments {
  final Key key;
  MapPageArguments({this.key});
}

//TownListPage arguments holder class
class TownListPageArguments {
  final Key key;
  TownListPageArguments({this.key});
}
