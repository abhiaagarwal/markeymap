import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:markeymap/localization.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/resources.dart' as resources;
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
        resources.Image.header,
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
            const _Logo(),
          ],
        ),
      );
}

class _Logo extends StatelessWidget {
  const _Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox.expand(
            child: Image.asset(
              resources.Image.logo,
              bundle: DefaultAssetBundle.of(context),
              height: 1346,
              width: 657,
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

  Widget _searchText(BuildContext context) => Text(
        MarkeyMapLocalizations.of(context).searchBar,
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
                  _searchText(context),
                ],
              ),
            ),
          ),
        ),
      );
}
