import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:gsheets/gsheets.dart' as sheets;

import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class MarkeyMapData extends InheritedWidget {
  final Map<County, List<Town>> data;
  MarkeyMapData({Key key, @required Widget child, @required this.data})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(MarkeyMapData oldWidget) => oldWidget.data != data;

  static MarkeyMapData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MarkeyMapData>();
}

class MarkeyMapBuilder extends StatefulWidget {
  final sheets.GSheets api;
  final String sheetId;
  final Widget child;
  MarkeyMapBuilder(
      {@required String credentials,
      @required this.sheetId,
      @required this.child,
      Key key})
      : api = sheets.GSheets(credentials),
        super(key: key);

  @override
  _MarkeyMapBuilderState createState() => _MarkeyMapBuilderState();
}

class _MarkeyMapBuilderState extends State<MarkeyMapBuilder> {
  Future<Map<County, List<Town>>> get _data async {
    final sheets.Spreadsheet spreadsheet =
        await widget.api.spreadsheet(widget.sheetId);
    Map<County, List<Town>> countiesList = Map.fromIterable(
      County.values,
      key: (county) => county,
      value: (county) => [],
    );
    for (County county in [County.Dukes, County.Essex]) {
      LinkedHashMap<String, List<EdAction>> towns = LinkedHashMap();
      final sheets.Worksheet worksheet =
          spreadsheet.worksheetByTitle(county.name.toUpperCase());
      print("Getting worksheet for ${county.name}");
      List<List<String>> values =
          await worksheet.values.allRows(fromRow: 2, length: 6);
      values.forEach(
        (List<String> row) {
          final int length = row.length;
          final String townName = row[0];
          if (!towns.containsKey(townName)) {
            // Add missing key
            towns[townName] = [];
          }
          towns[townName].add(
            EdAction(
              date: row[1].isEmpty ? null : DateTime.now(),
              actionType: row[2].action,
              description: row[3],
              funding: length < 5 ? 0 : int.tryParse(row[4]),
              url: length < 6 ? '' : row[5],
            ),
          );
        },
      );
      towns.forEach(
        (String name, List<EdAction> actions) =>
            countiesList[county].add(Town(name, actions)),
      );
    }
    return countiesList;
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Map<County, List<Town>>>(
        future: _data,
        builder: (BuildContext context,
            AsyncSnapshot<Map<County, List<Town>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                return MarkeyMapData(
                  data: snapshot.data,
                  child: widget.child,
                );
              } else {
                return Container();
              }
              break;
            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }
}
