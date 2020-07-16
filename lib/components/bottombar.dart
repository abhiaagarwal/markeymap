import 'package:flutter/material.dart';
import 'package:markeymap/components/action_card.dart';
import 'package:markeymap/localization.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:markeymap/theme.dart';

import 'package:markeymap/popup.dart';
import 'package:markeymap/data.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';
import 'package:markeymap/components/welcome.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          spacing: 16,
          children: <Widget>[
            _BottomButton(
              text: MarkeyMapLocalizations.of(context).navigate,
              color: Theme.of(context).primaryColor,
              onTap: () => showPopup(context, body: const WelcomeScreen()),
            ),
            _BottomButton(
              text: MarkeyMapLocalizations.of(context).statewideAccomplishments,
              color: Theme.of(context).primaryColor,
              onTap: () => showPopup(
                context,
                title:
                    MarkeyMapLocalizations.of(context).statewideAccomplishments,
                scaffoldColor: Theme.of(context).primaryColor,
                body: () {
                  final Town statewide = MarkeyMapData.of(context)
                      .data[County.other]
                      .firstWhere((Town town) => town.name == 'Statewide');
                  return ActionCard(
                    name: statewide.name,
                    actions: statewide.actions,
                  );
                }(),
              ),
            ),
            _BottomButton(
              text: MarkeyMapLocalizations.of(context).donate,
              color: Theme.of(context).accentColor,
              onTap: () => url_launcher
                  .launch('https://secure.actblue.com/donate/markeymap'),
            ),
            _BottomButton(
              text: MarkeyMapLocalizations.of(context).getInvolved,
              color: Theme.of(context).accentColor,
              onTap: () =>
                  url_launcher.launch('https://www.edmarkey.com/volunteer/'),
            ),
          ],
        ),
      );
}

class _BottomButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final Color color;
  const _BottomButton(
      {@required this.text, @required this.onTap, this.color, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        color: color,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Text(
            text.toUpperCase(),
            style: MarkeyMapTheme.buttonStyle,
          ),
        ),
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
}
