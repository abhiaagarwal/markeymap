import 'package:flutter/material.dart';

import 'package:markeymap/components/town_card.dart';
import 'package:markeymap/components/popup.dart';

import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class TownList extends StatelessWidget {
  final County county;
  final List<Town> towns;
  const TownList({@required this.county, @required this.towns, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemExtent: 60.0,
        itemCount: towns.length,
        itemBuilder: (BuildContext context, final int index) => ListTile(
          title: Text(towns[index].name),
          onTap: () => showPopup(
            context,
            title: '',
            scaffoldColor: Theme.of(context).primaryColor,
            body: TownCard(
              town: towns[index],
              countyName: county.name,
            ),
          ),
        ),
      );
}
