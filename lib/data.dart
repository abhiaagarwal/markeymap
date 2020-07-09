import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gsheets/gsheets.dart' as sheets;

import 'package:markeymap/components/loading.dart';
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

  Future<void> _preloadSVGs(BuildContext context, List<String> towns) async {
    for (final String town in towns) {
      precachePicture(
        SvgPicture.asset(
          'assets/town_svgs/${town.trim().replaceAll(' ', '-')}.svg',
          bundle: DefaultAssetBundle.of(context),
        ).pictureProvider,
        context,
      );
    }
  }

  Future<Map<County, List<Town>>> _data(BuildContext context) async {
    final sheets.GSheets api = sheets.GSheets(
        await DefaultAssetBundle.of(context).loadString(credentialsFile));
    final sheets.Spreadsheet spreadsheet = await api.spreadsheet(sheetId);
    final Map<County, List<Town>> countiesList = <County, List<Town>>{
      for (final County county in County.values) county: <Town>[]
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
      compute<void, void>(
        (dynamic _) => _preloadSVGs(context, towns.keys.toList()),
        null,
      );
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
        ) =>
            AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: () {
            precacheImage(
              AssetImage(
                'assets/header.png',
                bundle: DefaultAssetBundle.of(context),
              ),
              context,
            );
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.data != null) {
                  return MarkeyMapData(
                    key: const ValueKey<int>(2),
                    data: snapshot.data,
                    child: child,
                  );
                } else {
                  return Container(
                    key: const ValueKey<int>(3),
                  );
                }
                break;
              default:
                return const Loading(
                  key: ValueKey<int>(1),
                );
            }
          }(),
        ),
      );
}
