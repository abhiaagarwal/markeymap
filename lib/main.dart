import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/theme.dart';
import 'package:markeymap/router.gr.dart';

void main() => runApp(const MarkeyMapApp());

class MarkeyMapApp extends StatelessWidget {
  const MarkeyMapApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Markey Map',
        theme: MarkeyMapTheme.theme,
        builder: (BuildContext context, Widget navigator) => MarkeyMapBuilder(
          credentialsFile: 'assets/credentials.json',
          sheetId: '18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ',
          child: ExtendedNavigator<Router>(
            router: Router(),
          ),
        ),
      );
}
