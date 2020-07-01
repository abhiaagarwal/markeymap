import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money2/money2.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/models/action.dart';

class ActionCard extends StatelessWidget {
  final String name;
  final List<EdAction> actions;
  final double totalSecured;
  const ActionCard({@required this.name, @required this.actions, this.totalSecured, Key key})
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
  Widget build(BuildContext context) => Title(
      title: name,
      color: Theme.of(context).primaryColor,
      child: Container(
          decoration: _gradient,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ).copyWith(bottom: 8),
          child: SizedBox(
            child: ListView.builder(
              itemCount: actions.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 1 - 1) {
                  return _ActionHeader(
                    name: name,
                  );
                }
                if (index == (actions.length + 2) - 1) {
                  if (totalSecured == null || totalSecured == 0.0) {
                    return null;
                  }
                  return _TotalSecured(totalSecured: totalSecured);
                }
                return _ActionTileCard(
                  action: actions[index - 1],
                );
              },
            ),
          ),
        ),
  );
}

class _ActionHeader extends StatelessWidget {
  final String name;
  const _ActionHeader(
      {@required this.name, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/town_svgs/${name.trim().replaceAll(' ', '-')}.svg',
            bundle: DefaultAssetBundle.of(context),
            height: MarkeyMapTheme.cardHeaderStyle.fontSize * 4.5,
            width: MarkeyMapTheme.cardHeaderStyle.fontSize * 4.5,
          ),
          FittedBox(
            child: Text(
              name.toUpperCase(),
              textAlign: TextAlign.center,
              style: MarkeyMapTheme.cardHeaderStyle,
            ),
          ),
        ],
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

class _TotalSecured extends StatelessWidget {
  final double totalSecured;
  const _TotalSecured({@required this.totalSecured, Key key}) : super(key: key);

  String get _formattedMoney => Money.from(
        totalSecured,
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
