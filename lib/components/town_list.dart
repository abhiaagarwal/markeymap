import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:markeymap/components/action_card.dart';
import 'package:markeymap/localization.dart';
import 'package:markeymap/popup.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class TownList extends StatelessWidget {
  final County county;
  final List<Town> towns;
  const TownList({@required this.county, @required this.towns, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Title(
        title: MarkeyMapLocalizations.of(context).countyName(county.name),
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
          itemExtent: 50.0,
          itemCount: towns.length,
          itemBuilder: (BuildContext context, final int index) => ListTile(
            title: Text(
              towns[index].name,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => showPopup(
              context,
              scaffoldColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.transparent,
              body: ActionCard(
                name: towns[index].name,
                actions: towns[index].actions,
                totalSecured: towns[index].totalSecured,
                zipcode: towns[index].zipcode,
              ),
            ),
          ),
        ),
      );
}
/*
  @override
  Widget build(BuildContext context) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
        ),
        itemCount: towns.length,
        itemBuilder: (BuildContext context, final int index) =>
            TownGridItem(town: towns[index], countyName: county.name),
      );
}
class TownGridItem extends StatelessWidget {
  final Town town;
  final String countyName;
  const TownGridItem({@required this.town, @required this.countyName, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => showPopup(
            context,
            title: '',
            scaffoldColor: Theme.of(context).primaryColor,
            body: ActionCard(name: town.name, actions: town.actions),
          ),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/town_svgs/${town.name.trim().replaceAll(' ', '-')}.svg',
              bundle: DefaultAssetBundle.of(context),
              height: MarkeyMapTheme.cardHeaderStyle.fontSize * 4,
              width: MarkeyMapTheme.cardHeaderStyle.fontSize * 4,
              semanticsLabel: town.name,
            ),
            FittedBox(
              child: Text(
                town.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: MarkeyMapTheme.cardHeaderStyle,
              ),
            ),
          ],
        ),
      ));
}
*/
