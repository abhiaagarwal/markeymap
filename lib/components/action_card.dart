import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money2/money2.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/models/action.dart';

Future<void> _launchUrl(final String url) async {
  if (url == null) {
    return;
  }
  if (await url_launcher.canLaunch(url)) {
    await url_launcher.launch(url);
  }
  return;
}

class ActionCard extends StatelessWidget {
  final String name;
  final List<EdAction> actions;
  final double totalSecured;
  final String zipcode;
  const ActionCard(
      {@required this.name,
      @required this.actions,
      this.totalSecured,
      this.zipcode,
      Key key})
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
          child: Column(
            children: <Widget>[
              _ActionList(
                  name: name, actions: actions, totalSecured: totalSecured),
              _CallToActionBar(name: name, zipcode: zipcode),
            ],
          ),
        ),
      );
}

class _ActionList extends StatelessWidget {
  final String name;
  final List<EdAction> actions;
  final double totalSecured;
  _ActionList({this.name, this.actions, this.totalSecured, Key key})
      : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => Expanded(
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(maxWidth: 800),
            alignment: Alignment.center,
            child: ListView.builder(
              controller: _scrollController,
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
  const _ActionHeader({@required this.name, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            SizedBox(
              height: MarkeyMapTheme.svgHeight,
              child: FractionallySizedBox(
                heightFactor: 0.8,
                child: SvgPicture.asset(
                  'assets/town_svgs/${name.trim().replaceAll(' ', '-')}.svg',
                  bundle: DefaultAssetBundle.of(context),
                  height: 1366,
                  width: 738,
                ),
              ),
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
x[]
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
            style: MarkeyMapTheme.cardListStyle.copyWith(
              fontWeight: FontWeight.w700,
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
          onTap: () async => _launchUrl(action.url),
          child: Text(
            action.description,
            style: MarkeyMapTheme.cardListStyle,
          ),
        ),
      );

  Widget get _endorsedPart => Expanded(
        flex: 5,
        child: RichText(
          text: TextSpan(
            text: 'Local Endorsements: ',
            style: MarkeyMapTheme.cardListStyle.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(
                text: action.description,
                style: MarkeyMapTheme.cardListStyle.copyWith(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _datePart,
            () {
              if (action.type == ActionType.Endorsement) {
                return _endorsedPart;
              } else {
                return _descriptionPart;
              }
            }(),
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
          style: MarkeyMapTheme.cardListStyle.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
          ),
          children: <TextSpan>[
            TextSpan(
              text: _formattedMoney,
              style: MarkeyMapTheme.cardListStyle.copyWith(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
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

class _CallToActionBar extends StatelessWidget {
  final String name;
  final String zipcode;
  const _CallToActionBar({this.name, this.zipcode, Key key}) : super(key: key);

  Widget get _ctaText => Text(
        'Help Ed continue to fight for $name:'.toUpperCase(),
        style: MarkeyMapTheme.buttonStyle.copyWith(fontWeight: FontWeight.w700),
      );

  String get _donateLink => Uri.https(
        'secure.actblue.com',
        '/donate/markeymap',
        <String, String>{
          'refcode': name,
          'amount': (int.tryParse(zipcode) / 100).toString(),
        },
      ).toString();

  String get _volunteerLink => "${Uri.https(
        'edmarkey.com',
        '/volunteer',
        <String, String>{
          'pc': zipcode,
          'results': true.toString(),
          'radius': 25.toString(),
          'sort': 2.toString(),
        },
      ).toString()}#formatted-events";

  BoxDecoration get _gradient => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color(0xFF005B97),
            Color(0xFFCCE0F4),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: _gradient,
        height: 64,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _ctaText,
              ),
              _CallToActionButton(
                text: 'Donate',
                onTap: () => _launchUrl(_donateLink),
                color: MarkeyMapTheme.theme.accentColor,
              ),
              _CallToActionButton(
                text: 'Volunteer',
                onTap: () => _launchUrl(_volunteerLink),
                color: MarkeyMapTheme.theme.accentColor,
              ),
            ],
          ),
        ),
      );
}

class _CallToActionButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final Color color;
  const _CallToActionButton(
      {@required this.text, @required this.onTap, this.color, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FlatButton(
          color: color,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Text(
              text.toUpperCase(),
              style: MarkeyMapTheme.buttonStyle,
            ),
          ),
          onPressed: onTap,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
}
