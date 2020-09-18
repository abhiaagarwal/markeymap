import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:markeymap/components/loading.dart';
import 'package:markeymap/components/youtube_container.dart';
import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/town.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/data/database.dart';
import 'package:markeymap/localization.dart';
import 'package:markeymap/resources.dart';
import 'package:markeymap/theme.dart';

Future<void> _launchUrl(final String url) async {
  if (url == null) {
    return;
  }
  if (await url_launcher.canLaunch(url)) {
    await url_launcher.launch(url);
  }
  return;
}

class ActionCard extends StatefulWidget {
  const ActionCard({
    @required this.town,
    @required this.county,
    Key key,
  }) : super(key: key);

  final Town town;
  final County county;

  @override
  _ActionCardState createState() => _ActionCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty<Town>('town', town))
      ..add(EnumProperty<County>('county', county));
    super.debugFillProperties(properties);
  }
}

class _ActionCardState extends State<ActionCard> {
  Future<List<EdAction>> _actions;

  @override
  void initState() {
    super.initState();
    _actions = Provider.of<Database>(context, listen: false)
        .getActions(widget.county, widget.town);
  }

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
        title: widget.town.name,
        color: Theme.of(context).primaryColor,
        child: DecoratedBox(
          decoration: _gradient,
          child: Column(
            children: <Widget>[
              Expanded(
                child: FutureLoader<List<EdAction>>(
                  future: _actions,
                  builder: (BuildContext context, List<EdAction> actions) =>
                      _ActionList(
                    name: widget.town.name,
                    actions: actions,
                    totalSecured: actions.totalSecured,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _CallToActionBar(
                  name: widget.town.name,
                  zipcode: widget.town.zipcode,
                ),
              ),
            ],
          ),
        ),
      );
}

class _ActionList extends StatelessWidget {
  const _ActionList({
    @required this.name,
    @required this.actions,
    this.totalSecured,
    Key key,
  }) : super(key: key);

  final String name;
  final List<EdAction> actions;
  final double totalSecured;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final bool showSecured = !(totalSecured == null || totalSecured == 0.0);
    return Scrollbar(
      controller: scrollController,
      isAlwaysShown: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints(maxWidth: 800),
        alignment: Alignment.center,
        child: RepaintBoundary(
          child: CustomScrollView(
            controller: scrollController,
            semanticChildCount: 1 + actions.length + (showSecured ? 1 : 0),
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: MarkeyMapTheme.cardHeaderHeight,
                automaticallyImplyLeading: false,
                flexibleSpace: _ActionHeader(name: name),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, final int index) => _ActionTileCard(
                    action: actions[index],
                  ),
                  childCount: actions.length,
                  addRepaintBoundaries: false,
                ),
              ),
              if (showSecured)
                SliverToBoxAdapter(
                  child: _TotalSecured(totalSecured: totalSecured),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(StringProperty('name', name))
      ..add(IterableProperty<EdAction>('actions', actions))
      ..add(DoubleProperty('totalSecured', totalSecured));
    super.debugFillProperties(properties);
  }
}

class _ActionHeader extends StatelessWidget {
  const _ActionHeader({
    @required this.name,
    Key key,
  }) : super(key: key);

  final String name;

  Widget _image(BuildContext context) => SvgPicture.asset(
        Provider.of<Resource>(context).svg.townSvg(name),
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
            height: MarkeyMapTheme.cardHeaderHeight,
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: _image(context),
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(StringProperty('name', name));
    super.debugFillProperties(properties);
  }
}

class _ActionTileCard extends StatelessWidget {
  const _ActionTileCard({
    @required this.action,
    Key key,
  }) : super(key: key);

  final EdAction action;

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
                fontFeatures: const <ui.FontFeature>[
                  ui.FontFeature.tabularFigures(),
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
            text: 'Local Endorsements:',
            style: MarkeyMapTheme.cardListStyle.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              const TextSpan(
                text: ' ',
              ),
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

  Widget get _youtubePart => Expanded(
        flex: 5,
        child: YoutubeContainer(
          title: action.description,
          url: action.url,
          height: double.infinity,
          width: double.infinity,
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
              switch (action.type) {
                case ActionType.endorsement:
                  return _endorsedPart;
                case ActionType.youtube:
                  return _youtubePart;
                default:
                  return _descriptionPart;
              }
            }(),
          ],
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<EdAction>('action', action));
    super.debugFillProperties(properties);
  }
}

class _TotalSecured extends StatelessWidget {
  const _TotalSecured({
    @required this.totalSecured,
    Key key,
  }) : super(key: key);

  final double totalSecured;

  String get _formattedMoney => NumberFormat.currency(
        symbol: '\$',
        decimalDigits: 2,
      ).format(totalSecured);

  Widget _text(BuildContext context) => RichText(
        text: TextSpan(
          text: 'Total Secured:',
          style: MarkeyMapTheme.cardListStyle.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
          ),
          children: <TextSpan>[
            const TextSpan(
              text: ' ',
            ),
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
            Expanded(
              flex: 5,
              child: _text(context),
            ),
          ],
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DoubleProperty('totalSecured', totalSecured));
    super.debugFillProperties(properties);
  }
}

class _CallToActionBar extends StatelessWidget {
  const _CallToActionBar({
    @required this.name,
    this.zipcode,
    Key key,
  }) : super(key: key);

  final String name;
  final String zipcode;

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
        width: double.infinity,
        decoration: _gradient,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(StringProperty('name', name))
      ..add(StringProperty('zipcode', zipcode));
    super.debugFillProperties(properties);
  }
}

class _CallToActionButton extends StatelessWidget {
  const _CallToActionButton({
    @required this.text,
    @required this.onTap,
    this.color,
    Key key,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FlatButton(
          color: color,
          onPressed: onTap,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              text.toUpperCase(),
              style: MarkeyMapTheme.buttonStyle,
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(StringProperty('text', text))
      ..add(ObjectFlagProperty<VoidCallback>(
        'onTap',
        onTap,
        ifPresent: 'present',
      ))
      ..add(ColorProperty('color', color));
    super.debugFillProperties(properties);
  }
}
