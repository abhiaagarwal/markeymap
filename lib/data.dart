import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:gsheets/gsheets.dart' as sheets;

import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class MarkeyMapData extends InheritedWidget {
  final Map<County, List<Town>> data;
  const MarkeyMapData({Key key, @required Widget child, @required this.data})
      : super(key: key, child: child);

  SplayTreeMap<Town, County> get townsByCounty {
    final SplayTreeMap<Town, County> map = SplayTreeMap<Town, County>(
      (Town a, Town b) => a.name.compareTo(b.name),
    );
    for (final MapEntry<County, List<Town>> entry in data.entries) {
      for (final Town town in entry.value) {
        map[town] = entry.key;
      }
    }
    return map;
  }

  @override
  bool updateShouldNotify(MarkeyMapData oldWidget) => oldWidget.data != data;

  static MarkeyMapData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MarkeyMapData>();
}

class MarkeyMapBuilder extends StatelessWidget {
  final String credentialsFile;
  final String sheetId;
  final Widget child;
  const MarkeyMapBuilder(
      {@required this.credentialsFile,
      @required this.sheetId,
      @required this.child,
      Key key})
      : super(key: key);

  Future<Map<County, List<Town>>> _data(BuildContext context) async {
    final sheets.GSheets api = sheets.GSheets(
        await DefaultAssetBundle.of(context).loadString(credentialsFile));
    final sheets.Spreadsheet spreadsheet = await api.spreadsheet(sheetId);
    final Map<County, List<Town>> countiesList = <County, List<Town>>{
      for (County county in County.values) county: <Town>[]
    };
    for (final County county in countiesList.keys) {
      final LinkedHashMap<String, List<EdAction>> towns =
          LinkedHashMap<String, List<EdAction>>();

      final Map<String, String> townZipcodes = <String, String>{};
      final List<EdAction> countyActions = <EdAction>[];

      for (final List<String> row in await spreadsheet
          .worksheetByTitle(county.name.toUpperCase())
          .values
          .allRows(fromRow: 2, length: 7)) {
        try {
          final String townName = row[0];
          if (townName.isEmpty) {
            countyActions.add(EdAction.fromRow(row));
            continue;
          }
          towns.update(
            townName,
            (List<EdAction> actions) => actions..add(EdAction.fromRow(row)),
            ifAbsent: () => <EdAction>[EdAction.fromRow(row)],
          );
          if (!townZipcodes.containsKey(townName)) {
            townZipcodes[townName] = row[6];
          }
        } catch (e) {
          print('Error while parsing $row, exception $e');
        }
      }
      towns.forEach(
        (String name, List<EdAction> actions) => countiesList[county].add(
          Town(
            name: name,
            actions: actions + countyActions,
            zipcode: townZipcodes[name],
          ),
        ),
      );
    }
    return countiesList;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<County, List<Town>>>(
        future: _data(context),
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<County, List<Town>>> snapshot,
        ) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                return MarkeyMapData(
                  data: snapshot.data,
                  child: child,
                );
              } else {
                return Container();
              }
              break;
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      );
}
