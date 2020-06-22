import 'package:flutter/material.dart';

import 'package:markeymap/components/map.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/theme.dart' as theme;

void main() => runApp(MarkeyMapApp());

class MarkeyMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Markey Map",
        theme: theme.theme,
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(58),
            child: AppBar(
              title: Text("Markey Map"),
            ),
          ),
          body: PreferencesBuilder(
            child: ScaledMap(),
          ),
        ),
      );
}

class PreferencesBuilder extends StatefulWidget {
  final Widget child;
  PreferencesBuilder({@required this.child, Key key}) : super(key: key);

  @override
  _PreferencesBuilderState createState() => _PreferencesBuilderState();
}

class _PreferencesBuilderState extends State<PreferencesBuilder> {
  Widget build(BuildContext context) => FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/credentials.json'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return MarkeyMapBuilder(
                credentials: snapshot.data,
                sheetId: "18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ",
                child: widget.child,
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      );
}
