import 'package:flutter/material.dart';

import 'package:markeymap/components/appbar.dart';
import 'package:markeymap/components/map.dart';
import 'package:markeymap/components/bottombar.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key key}) : super(key: key);

  static const String route = '/';

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: MainAppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: FittedBox(
              child: InteractiveMap(),
            ),
          ),
        ),
        bottomSheet: BottomBar(),
      );
}
