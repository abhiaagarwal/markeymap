import 'package:flutter/material.dart';

import 'package:markeymap/components/map.dart';
import 'package:markeymap/components/search.dart';
import 'package:markeymap/components/welcome.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/theme.dart';

void main() => runApp(MarkeyMapApp());

class MarkeyMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Markey Map',
        theme: MarkeyMapTheme.theme,
        home: MarkeyMapBuilder(
          credentialsFile: 'assets/credentials.json',
          sheetId: '18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ',
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(128),
              child:
                  /*
                  Column(
                  children: <Widget>[
                    PreferredSize(
                      preferredSize: const Size.fromHeight(104),
                      child: Stack(
                        //fit: StackFit.expand,
                        children: <Widget>[
                          Container(color: MarkeyMapTheme.theme.primaryColor),
                          Center(
                            child: Text(
                              'Markey Map'.toUpperCase(),
                              style: MarkeyMapTheme.appBarStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PreferredSize(
                      preferredSize: const Size.fromHeight(24),
                      child: Container(color: Colors.red),
                    ),
                  ],
                ),*/
                  AppBar(
                title: Text(
                  'Markey Map'.toUpperCase(),
                  style: MarkeyMapTheme.appBarStyle,
                ),
                actions: const <Widget>[
                  SearchButton(),
                  WelcomeButton(),
                ],
                bottom: PreferredSize(
                  child: Container(
                    color: MarkeyMapTheme.theme.accentColor,
                  ),
                  preferredSize: const Size.fromHeight(12),
                ),
              ),
            ),
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  ScaledMap(
                scaleFactor: 0.9,
                size: MediaQuery.of(context).size,
              ),
            ),
          ),
        ),
      );
}
