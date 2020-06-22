import 'package:flutter/material.dart';

import 'package:markeymap/components/towncard.dart';
import 'package:markeymap/components/popup.dart';

import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class CountyList extends StatelessWidget {
  final County county;
  final List<Town> towns;
  CountyList({@required this.county, @required this.towns, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: towns.length,
        itemBuilder: (BuildContext context, int index) {
          final Town town = towns[index];
          return ListTile(
            title: Text(town.name),
            onTap: () => showPopup(
              context,
              title: "Town",
              widget: TownCard(town: town),
            ),
          );
        },
      );
}
