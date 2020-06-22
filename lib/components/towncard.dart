import 'package:flutter/material.dart';

import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/town.dart';

class TownCard extends StatelessWidget {
  final Town town;
  TownCard({@required this.town, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TownHeader(name: town.name),
        Expanded(
          child: SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: town.actions.length,
              itemBuilder: (context, index) =>
                  _ActionTileCard(action: town.actions[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _TownHeader extends StatelessWidget {
  final String name;
  _TownHeader({@required this.name, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        new Text(
          name,
          style: TextStyle(),
        ),
      ],
    );
  }
}

class _ActionTileCard extends StatelessWidget {
  final EdAction action;
  _ActionTileCard({@required this.action, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(child: Text("Date")),
        ),
        Expanded(
          flex: 6,
          child: Text(action.description),
        ),
      ],
    );
  }
}

class _TotalRaised extends StatelessWidget {
  final int totalRaised;
  _TotalRaised({@required this.totalRaised, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Total Raised: ${totalRaised.toString()}");
  }
}
