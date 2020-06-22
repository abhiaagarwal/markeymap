import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:markeymap/theme.dart';
import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/town.dart';
import 'package:url_launcher/url_launcher.dart';

class TownCard extends StatelessWidget {
  final Town town;
  TownCard({@required this.town, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Colors.black.withAlpha(64),
            Colors.transparent,
          ]
        )
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: _TownHeader(name: town.name),
          ),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 32),
                itemCount: town.actions.length,
                itemBuilder: (context, index) =>
                    _ActionTileCard(action: town.actions[index]),
              ),
            ),
          ),
        ],
      ),
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
          name.toUpperCase(),
          style: MarkeyMapTheme.cardHeaderStyle,
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
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                action.date?.format("dd, MMM yyyy") ?? "",
                style: MarkeyMapTheme.cardListStyle
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () async {
                final String url = action.url;
                if (await url_launcher.canLaunch(url)) {
                  await url_launcher.launch(url);
                }
              },
              child: Text(
                action.description,
                style: MarkeyMapTheme.cardListStyle,
              ),
            ),
          ),
        ],
      ),
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
