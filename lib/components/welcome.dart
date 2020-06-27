import 'package:flutter/material.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/popup.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.info),
        onPressed: () => showPopup(
          context,
          body: const WelcomeScreen(),
          scaffoldColor: Theme.of(context).accentColor,
        ),
      );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Column(
            children: <Widget>[
              _WelcomeHeader(),
            ],
          ),
        ),
      );
}

class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text(
        'Welcome to the Markey Map!'.toUpperCase(),
        style: MarkeyMapTheme.welcomeHeaderStyle,
      );
}
