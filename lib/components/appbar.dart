import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/components/search.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        elevation: 2.0,
        child: Column(
          children: <Widget>[
            Container(
              height: 24,
              width: double.infinity,
              color: MarkeyMapTheme.theme.accentColor,
            ),
            const _Header(),
            const _SearchBar(),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(24.0 + 196.0 + 48.0);
}

class _Header extends StatelessWidget {
  const _Header({Key key}) : super(key: key);

  Widget _image(BuildContext context) => Image.asset(
        'assets/header.png',
        bundle: DefaultAssetBundle.of(context),
        color: Theme.of(context).primaryColor,
        colorBlendMode: BlendMode.softLight,
        fit: BoxFit.cover,
        repeat: ImageRepeat.repeatX,
      );

  @override
  Widget build(BuildContext context) => Container(
        height: 196.0,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            _image(context),
            const _HeaderText(),
          ],
        ),
      );
}

class _HeaderText extends StatelessWidget {
  const _HeaderText({Key key}) : super(key: key);

  Widget get _markey => Text(
        'Markey'.toUpperCase(),
        style: MarkeyMapTheme.appBarStyle,
      );

  Widget _compass(BuildContext context) => Container(
        child: SvgPicture.asset(
          'assets/compass.svg',
          bundle: DefaultAssetBundle.of(context),
          height: 42,
          width: 42,
        ),
      );

  Widget get _map => Text(
        'Map'.toUpperCase(),
        style: MarkeyMapTheme.appBarStyle,
      );

  @override
  Widget build(BuildContext context) => FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                _markey,
                Row(
                  children: <Widget>[
                    _compass(context),
                    _map,
                  ],
                )
              ],
            ),
          ),
        ),
      );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key key}) : super(key: key);

  Widget get _searchIcon => const Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(
          Icons.search,
          size: 16,
          color: Colors.white,
        ),
      );

  Widget get _searchText => const Text(
        'Search your town, city, or county to find out what Ed has done for your community',
        style: MarkeyMapTheme.searchBarStyle,
      );

  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        width: double.infinity,
        color: const Color(0xFF00345C),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: InkWell(
            onTap: () => handleSearch(context),
            mouseCursor: SystemMouseCursors.text,
            child: FittedBox(
              child: Row(
                children: <Widget>[
                  _searchIcon,
                  _searchText,
                ],
              ),
            ),
          ),
        ),
      );
}
