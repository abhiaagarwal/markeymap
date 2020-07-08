import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/components/action_card.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({Key key}) : super(key: key);

  static const String route = 'county/:county/:town';

  @override
  Widget build(BuildContext context) {
    final County county =
        RouteData.of(context).pathParams['county'].stringValue.county;
    final Town town = MarkeyMapData.of(context).data[county].firstWhere(
          (Town element) =>
              element.name.toLowerCase() ==
              RouteData.of(context)
                  .pathParams['town']
                  .stringValue
                  .toLowerCase(),
        );
    return ActionCard(
      name: town.name,
      actions: town.actions,
      totalSecured: town.totalSecured,
    );
  }
}
