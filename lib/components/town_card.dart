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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 32,
          ),
          child: Column(
            children: <Widget>[
              _TownHeader(
                townName: town.name,
                countyName: countyName,
              ),
              _ActionListView(
                actions: town.actions,
              ),
              /*
            _TotalRaised(
              totalRaised: town.totalFundraised,
            ),
            */
            ],
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            SvgPicture.asset(
              'town_svgs/$countyName/${townName.replaceAll(' ', '-')}.svg',
              bundle: DefaultAssetBundle.of(context),
              height: MarkeyMapTheme.cardHeaderStyle.fontSize * 4,
              width: MarkeyMapTheme.cardHeaderStyle.fontSize * 4,
            ),
            Text(
              townName.toUpperCase(),
              style: MarkeyMapTheme.cardHeaderStyle,
            ),
          ],
        ),
      );
}

class _ActionListView extends StatelessWidget {
  final List<EdAction> actions;
  const _ActionListView({@required this.actions, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: SizedBox(
          child: ListView.builder(
            itemCount: actions.length,
            itemBuilder: (BuildContext context, int index) => _ActionTileCard(
              action: actions[index],
            ),
          ),
        ),
      );
}

class _ActionTileCard extends StatelessWidget {
  final EdAction action;
  const _ActionTileCard({@required this.action, Key key}) : super(key: key);

  Widget get _datePart => Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            action.date?.format('dd, MMM yyyy') ?? '',
            textAlign: TextAlign.right,
            style: MarkeyMapTheme.cardListStyle
                .copyWith(fontWeight: FontWeight.w600),
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
  final int totalRaised;
  const _TotalRaised({@required this.totalRaised, Key key}) : super(key: key);

  String get _formattedMoney => Money.fromInt(
        totalRaised,
        Currency.create(
          'USD',
          2,
          pattern: 'S0,000.00',
        ),
      ).toString();

  Widget get _text => RichText(
        text: TextSpan(
          text: 'Total Fundrasied: ',
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
  Widget build(BuildContext context) => Row(
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
      );
}
