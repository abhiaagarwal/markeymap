import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:markeymap/components/search.dart';
import 'package:markeymap/localization.dart';
import 'package:markeymap/resources.dart';
import 'package:markeymap/theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        elevation: 2,
        child: Column(
          children: const <Widget>[
            _ReturnBar(),
            _Header(),
            _SearchBar(),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(20.0 + 196.0 + 48.0);
}

class _ReturnBar extends StatelessWidget {
  const _ReturnBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 20,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        color: MarkeyMapTheme.theme.accentColor,
        child: InkWell(
          onTap: () async => await url_launcher.launch('https://edmarkey.com'),
          mouseCursor: SystemMouseCursors.click,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '←',
                style: MarkeyMapTheme.returnStyle,
                children: <TextSpan>[
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: MarkeyMapLocalizations.of(context)
                        .returnText
                        .toUpperCase(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 196,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: const <Widget>[
            _Image(),
            _Logo(),
          ],
        ),
      );
}

class _Image extends StatelessWidget {
  const _Image({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Image.asset(
        Provider.of<Resource>(context).images.header,
        bundle: DefaultAssetBundle.of(context),
        height: 1366,
        width: 213,
        color: Theme.of(context).primaryColor,
        colorBlendMode: BlendMode.softLight,
        fit: BoxFit.cover,
        repeat: ImageRepeat.repeatX,
      );
}

class _Logo extends StatelessWidget {
  const _Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: SizedBox.expand(
            child: FadeInImage(
              height: 1346,
              width: 657,
              image: AssetImage(
                Provider.of<Resource>(context).images.logo,
                bundle: DefaultAssetBundle.of(context),
              ),
              placeholder: MemoryImage(kTransparentImage),
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
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
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
      );
}
