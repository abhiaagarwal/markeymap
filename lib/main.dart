import 'package:flutter/material.dart';

import 'package:markeymap/components/appbar.dart';
import 'package:markeymap/components/map.dart';
import 'package:markeymap/components/bottombar.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/resources.dart' as resources;
import 'package:markeymap/theme.dart';

void main() => runApp(const MarkeyMapApp());

class MarkeyMapApp extends StatelessWidget {
  const MarkeyMapApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Markey Map',
        theme: MarkeyMapTheme.theme,
        home: const MarkeyMapBuilder(
          credentialsFile: resources.Data.credentials,
          sheetId: '18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ',
          child: Scaffold(
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
          ),
        ),
      );
}
