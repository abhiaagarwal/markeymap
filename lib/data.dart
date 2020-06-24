import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:gsheets/gsheets.dart' as sheets;
import 'package:jiffy/jiffy.dart';

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

class MarkeyMapBuilder extends StatefulWidget {
  final String credentialsFile;
  final String sheetId;
  final Widget child;
  const MarkeyMapBuilder(
      {@required this.credentialsFile,
      @required this.sheetId,
      @required this.child,
      Key key})
      : super(key: key);

  @override
  _MarkeyMapBuilderState createState() => _MarkeyMapBuilderState();
}

class _MarkeyMapBuilderState extends State<MarkeyMapBuilder> {
  Future<Map<County, List<Town>>> get _data async {
    final sheets.GSheets api = sheets.GSheets(
        await DefaultAssetBundle.of(context)
            .loadString(widget.credentialsFile));
    final sheets.Spreadsheet spreadsheet =
        await api.spreadsheet(widget.sheetId);
    final Map<County, List<Town>> countiesList =
        // ignore: prefer_for_elements_to_map_fromiterable
        Map<County, List<Town>>.fromIterable(
      County.values,
      key: (dynamic county) => county as County,
      value: (dynamic county) => <Town>[],
    );
    for (final County county in <County>[
      County.Barnstable,
      County.Bristol,
      County.Dukes,
      County.Franklin,
      County.Essex,
      County.Hampden,
      County.Hampshire,
      County.Middlesex,
      County.Nantucket,
      County.Norfolk,
      County.Plymouth,
    ]) {
      final LinkedHashMap<String, List<EdAction>> towns =
          LinkedHashMap<String, List<EdAction>>();
      for (final List<String> row in await spreadsheet
          .worksheetByTitle(county.name.toUpperCase())
          .values
          .allRows(fromRow: 2, length: 6)) {
        final int length = row.length;
        final String townName = row[0];
        if (!towns.containsKey(townName)) {
          towns[townName] = <EdAction>[];
        }
        towns[townName].add(
          EdAction(
            date: row[1].isEmpty
                ? null
                : Jiffy(
                    '10/20/2018',
                    'MM/dd/yyyy',
                  ),
            actionType: row[2].action,
            description: row[3],
            funding: length < 5 ? 0 : int.tryParse(row[4]),
            url: length < 6 ? '' : row[5],
          ),
        );
      }
      towns.forEach(
        (String name, List<EdAction> actions) =>
            countiesList[county].add(Town(name: name, actions: actions)),
      );
    }
    return countiesList;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<County, List<Town>>>(
        future: _data,
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<County, List<Town>>> snapshot,
        ) {
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
              return const Center(child: CircularProgressIndicator());
          }
        },
      );
}
