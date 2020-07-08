import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/components/town_list.dart';
import 'package:markeymap/models/county.dart';

class TownListPage extends StatelessWidget {
  const TownListPage({Key key}) : super(key: key);

  static const String route = '/county/:county';

  @override
  Widget build(BuildContext context) {
    final County county = RouteData.of(context).pathParams['county'].stringValue.county;
    return TownList(
      county: county,
      towns: MarkeyMapData.of(context).data[county],
    );
  }
}