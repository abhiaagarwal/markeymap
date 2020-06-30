import 'package:flutter/material.dart';

import 'package:markeymap/components/appbar.dart';
import 'package:markeymap/components/map.dart';
import 'package:markeymap/components/search.dart';
import 'package:markeymap/components/welcome.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/theme.dart';

void main() => runApp(const MarkeyMapApp());

class MarkeyMapApp extends StatelessWidget {
  const MarkeyMapApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Markey Map',
        theme: MarkeyMapTheme.theme,
        home: const MarkeyMapBuilder(
          credentialsFile: 'assets/credentials.json',
          sheetId: '18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ',
          child: Scaffold(
            appBar: MainAppBar(),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child:  FittedBox(
                  child: InteractiveMap(),
                ),
              ),
            ),
          ),
        ),
      );
}
