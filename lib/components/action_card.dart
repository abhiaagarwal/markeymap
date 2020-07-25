import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/resources.dart' as resources;
import 'package:markeymap/localization.dart';
import 'package:markeymap/models/action.dart';
import 'package:markeymap/utils/string.dart';

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
        title: name.toCapitalize(),
        color: Theme.of(context).primaryColor,
        child: DecoratedBox(
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
  const _ActionList({this.name, this.actions, this.totalSecured, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: const BoxConstraints(maxWidth: 800),
          alignment: Alignment.center,
          child: RepaintBoundary(
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
      ),
    );
  }
}

class _ActionHeader extends StatelessWidget {
  final String name;
  const _ActionHeader({@required this.name, Key key}) : super(key: key);

  Widget image(BuildContext context) => SvgPicture.asset(
        '${resources.SVG.townSvg}${name.toLowerCase().trim().replaceAll(' ', '-')}.svg',
        bundle: DefaultAssetBundle.of(context),
        height: 1366,
        width: 738,
        placeholderBuilder: (BuildContext context) => const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFF005B97),
                Color(0xFFCCE0F4),
              ],
            ),
            shape: BoxShape.circle,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          SizedBox(
            height: MarkeyMapTheme.svgHeight,
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: image(context),
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

class _ActionTileCard extends StatelessWidget {
  final EdAction action;
  const _ActionTileCard({@required this.action, Key key}) : super(key: key);

  Widget get _datePart => Expanded(
        flex: 1,
        child: FittedBox(
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
            if (action.date != null) _datePart,
            () {
              if (action.type == ActionType.endorsement) {
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

  String get _formattedMoney => NumberFormat.currency(
        symbol: '\$',
        decimalDigits: 2,
      ).format(totalSecured);

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
        padding: const EdgeInsets.symmetric(vertical: 16),
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
  const _CallToActionBar({@required this.name, this.zipcode, Key key})
      : super(key: key);

  Widget _ctaText(BuildContext context) => Text(
        MarkeyMapLocalizations.of(context).townCTA(name).toUpperCase(),
        style: MarkeyMapTheme.buttonStyle.copyWith(fontWeight: FontWeight.w700),
      );

  String get _donateLink => Uri.https(
        'secure.actblue.com',
        '/donate/markeymap',
        <String, String>{
          'refcode': name,
          'amount': (int.tryParse(zipcode ?? '100') / 100).toString(),
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
      )}#formatted-events";

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
        constraints: const BoxConstraints(maxHeight: 64),
        decoration: _gradient,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _ctaText(context),
              ),
              Row(
                children: <Widget>[
                  _CallToActionButton(
                    text: MarkeyMapLocalizations.of(context).donate,
                    onTap: () => _launchUrl(_donateLink),
                    color: MarkeyMapTheme.theme.accentColor,
                  ),
                  _CallToActionButton(
                    text: MarkeyMapLocalizations.of(context).volunteer,
                    onTap: () => _launchUrl(_volunteerLink),
                    color: MarkeyMapTheme.theme.accentColor,
                  ),
                ],
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
