import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money2/money2.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/town.dart';

class TownCard extends StatelessWidget {
  final Town town;
  final String countyName;
  const TownCard({@required this.town, @required this.countyName, Key key})
      : super(key: key);

  BoxDecoration get _gradient => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Colors.black.withAlpha(64),
            Colors.transparent,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: _gradient,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(bottom: 8),
        child: SizedBox(
          child: ListView.builder(
            itemCount: town.actions.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 1 - 1) {
                return _TownHeader(
                  townName: town.name,
                  countyName: countyName,
                );
              }
              if (index == (town.actions.length + 2) - 1) {
                final double totalFundraised = town.totalFundraised;
                if (totalFundraised == null || totalFundraised == 0.0) {
                  return null;
                }
                return _TotalRaised(totalRaised: town.totalFundraised);
              }
              return _ActionTileCard(
                action: town.actions[index - 1],
              );
            },
          ),
        ),
      );
}

class _TownHeader extends StatelessWidget {
  final String townName;
  final String countyName;
  const _TownHeader(
      {@required this.townName, @required this.countyName, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/town_svgs/$countyName/${townName.trim().replaceAll(' ', '-')}.svg',
            bundle: DefaultAssetBundle.of(context),
            height: MarkeyMapTheme.cardHeaderStyle.fontSize * 4.5,
            width: MarkeyMapTheme.cardHeaderStyle.fontSize * 4.5,
          ),
          FittedBox(
            child: Text(
              townName.toUpperCase(),
              textAlign: TextAlign.center,
              style: MarkeyMapTheme.cardHeaderStyle,
            ),
          ),
        ],
      );
}

/*
class _ActionListView extends StatelessWidget {
  final List<EdAction> actions;
  const _ActionListView({@required this.actions, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: SizedBox(
          child: ListView.builder(
            itemCount: actions.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _TownHeader(
                  townName: town.name,
                  countyName: countyName,
                );
              }
              return _ActionTileCard(
                action: actions[index - 1],
              );
            },
          ),
        ),
      );
}
*/

class _ActionTileCard extends StatelessWidget {
  final EdAction action;
  const _ActionTileCard({@required this.action, Key key}) : super(key: key);

  Widget get _datePart => Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            action.date ?? '',
            textAlign: TextAlign.right,
            style: MarkeyMapTheme.cardListStyle
                .copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: <FontFeature>[
                    const FontFeature.tabularFigures(),
                  ],
                ),
          ),
        ),
      );

  Widget get _descriptionPart => Expanded(
        flex: 5,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: () async => launchUrl(action.url),
          child: Text(
            action.description,
            style: MarkeyMapTheme.cardListStyle,
          ),
        ),
      );

  Future<void> launchUrl(final String url) async {
    if (url == null) {
      return;
    }
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    }
    return;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _datePart,
            _descriptionPart,
          ],
        ),
      );
}

class _TotalRaised extends StatelessWidget {
  final double totalRaised;
  const _TotalRaised({@required this.totalRaised, Key key}) : super(key: key);

  String get _formattedMoney => Money.from(
        totalRaised,
        Currency.create(
          'USD',
          2,
          pattern: 'S0,000.00',
        ),
      ).toString();

  Widget get _text => RichText(
        text: TextSpan(
          text: 'Total Secured: ',
          style: MarkeyMapTheme.cardListStyle,
          children: <TextSpan>[
            TextSpan(
              text: _formattedMoney,
              style: MarkeyMapTheme.cardListStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: SizedBox.shrink(),
            ),
            Expanded(
              flex: 5,
              child: _text,
            ),
          ],
        ),
      );
}
