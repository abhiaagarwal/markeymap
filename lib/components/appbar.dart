import 'package:flutter/material.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/components/search.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Container(
            height: 12,
            width: double.infinity,
            color: MarkeyMapTheme.theme.accentColor,
          ),
          const _Header(),
          const _SearchBar(),
        ],
      );

  @override
  Size get preferredSize => const Size.fromHeight(12.0 + 196.0 + 48.0);
}

class _Header extends StatelessWidget {
  const _Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 196.0,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/header.png',
              bundle: DefaultAssetBundle.of(context),
              color: Theme.of(context).primaryColor,
              colorBlendMode: BlendMode.softLight,
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeatX,
            ),
            FittedBox(
              child: Text(
                'Markey Map'.toUpperCase(),
                textAlign: TextAlign.center,
                style: MarkeyMapTheme.appBarStyle,
              ),
            ),
          ],
        ),
      );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        width: double.infinity,
        color: const Color(0xFF00345C),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: InkWell(
            onTap: () => handleSearch(context),
            child: FittedBox(
              child: Text(
                'Search your town, city, or county to find out what Ed has done for your community',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      );
}
