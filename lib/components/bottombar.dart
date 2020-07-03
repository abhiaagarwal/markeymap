import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:markeymap/theme.dart';

import 'package:markeymap/popup.dart';
import 'package:markeymap/components/town_list.dart';
import 'package:markeymap/data.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/components/welcome.dart';

class BottomBar extends StatelessWidget implements PreferredSizeWidget {
  const BottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _BottomButton(
              text: 'Info',
              color: Theme.of(context).primaryColor,
              onTap: () => showPopup(context, body: const WelcomeScreen()),
            ),
            _BottomButton(
              text: 'Other Accomplishments',
              color: Theme.of(context).primaryColor,
              onTap: () => showPopup(
                context,
                title: 'Other Accomplishments',
                scaffoldColor: Theme.of(context).primaryColor,
                body: TownList(
                  county: County.Other,
                  towns: MarkeyMapData.of(context).data[County.Other],
                ),
              ),
            ),
            _BottomButton(
              text: 'Donate',
              color: Theme.of(context).accentColor,
              onTap: () => url_launcher
                  .launch('https://secure.actblue.com/donate/markeymap'),
            ),
            _BottomButton(
              text: 'Get involved',
              color: Theme.of(context).accentColor,
              onTap: () =>
                  url_launcher.launch('https://www.edmarkey.com/volunteer/'),
            ),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _BottomButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final Color color;
  const _BottomButton(
      {@required this.text, @required this.onTap, this.color, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: RaisedButton(
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
        ),
      );
}
