import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/components/town_list.dart';
import 'package:markeymap/components/svg_map.dart';
import 'package:markeymap/components/popup.dart';

class ScaledMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    const double navBarHeight = 58;
    final double safeZoneHeight = MediaQuery.of(context).padding.bottom;

    const double scaleFactor = 0.8;

    final double x = (width / 2.0) - (38.73 / 2.0);
    final double y = (height / 2.0) -
        (22.26 / 2.0) -
        (safeZoneHeight / 2.0) -
        navBarHeight +
        28;
    final Offset offset = Offset(x, y);

    return SafeArea(
      child: Transform.scale(
        scale: (height / 22.26) * scaleFactor,
        child: Transform.translate(
          offset: offset,
          child: const InteractiveMap(),
        ),
      ),
    );
  }
}

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({Key key}) : super(key: key);

  @override
  _InteractiveMapState createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  @override
  Widget build(BuildContext context) => Stack(
        children:
            MarkeyMapData.of(context).data.keys.map(_buildCounty).toList(),
        fit: StackFit.passthrough,
      );

  Widget _buildCounty(County county) => ClipPath(
        child: Material(
          color: Theme.of(context).accentColor,
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            hoverColor: Theme.of(context).primaryColor,
            onTap: () => showPopup(
              context,
              title: '${county.name} County',
              body: TownList(
                county: county,
                towns: MarkeyMapData.of(context).data[county],
              ),
            ),
          ),
        ),
        clipper: _MapClipper(county),
      );
}

/*
class _MapPainter extends CustomPainter {
  final County county;
  _MapPainter(this.county);

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(
        county.path,
        Paint()
          ..strokeWidth = 0
          ..style = PaintingStyle.fill,
      );

  @override
  bool shouldRepaint(_MapPainter old) => true;

  @override
  bool shouldRebuildSemantics(_MapPainter old) => false;
}
*/

class _MapClipper extends CustomClipper<Path> {
  final County county;
  _MapClipper(this.county);

  @override
  Path getClip(Size size) => county.path;

  @override
  bool shouldReclip(_MapClipper old) => false;
}
