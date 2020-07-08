import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';

import 'package:markeymap/pages/map_page.dart';
import 'package:markeymap/pages/town_list_page.dart';

@CustomAutoRouter(
  routes: <AutoRoute>[
    CustomRoute<void>(
      page: MapPage,
      path: MapPage.route,
      initial: true,
    ),
    /*
    CustomRoute<void>(
      page: TownListPage,
      path: TownListPage.route,
    ),
    */
  ],
)
class $Router{}