import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/components/town_list.dart';
import 'package:markeymap/components/svg_map.dart';
import 'package:markeymap/popup.dart';

class InteractiveMap extends StatelessWidget {
  const InteractiveMap({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: CountySize.size.width,
        height: CountySize.size.height,
        child: Stack(
          children: MarkeyMapData.of(context)
              .data
              .keys
              .map<_CountyObject>((County county) => _CountyObject(county))
              .toList(),
          overflow: Overflow.visible,
        ),
      );
}

class _CountyObject extends StatelessWidget {
  final County county;
  @override
  const _CountyObject(this.county, {Key key}) : super(key: key);

  Widget _painter(BuildContext context) => CustomPaint(
        painter: _CountyPainter(
          county,
          Theme.of(context).primaryColor,
        ),
      );

  Widget _inkWell(BuildContext context) => InkWell(
        mouseCursor: SystemMouseCursors.click,
        hoverColor: Theme.of(context).primaryColor,
        highlightColor: const Color(0xFF00345C),
        onTap: () => showPopup(
          context,
          title: '${county.name} County',
          scaffoldColor: Theme.of(context).primaryColor,
          body: TownList(
            county: county,
            towns: MarkeyMapData.of(context).data[county],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Interactive County',
        hint: 'Press to view all actions',
        value: county.name,
        child: ClipPath(
          child: Material(
            color: const Color(0xFF8BC6FF),
            child: Stack(
              children: <Widget>[
                _painter(context),
                _inkWell(context),
              ],
            ),
          ),
          clipper: _CountyClipper(county),
        ),
      );
}

class _CountyPainter extends CustomPainter {
  final County county;
  final Color color;
  _CountyPainter(this.county, this.color);

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(
        county.path,
        Paint()
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFF00345C),
      );

  @override
  bool shouldRepaint(_CountyPainter old) => false;

  @override
  bool shouldRebuildSemantics(_CountyPainter old) => false;
}

class _CountyClipper extends CustomClipper<Path> {
  final County county;
  _CountyClipper(this.county);

  @override
  Path getClip(Size size) => county.path;

  @override
  bool shouldReclip(_CountyClipper old) => false;
}
