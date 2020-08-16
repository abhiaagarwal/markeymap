import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:markeymap/data/api.dart';

import 'package:gsheets/gsheets.dart' as gsheets;

import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class GSheetsApi extends Api {
  GSheetsApi({Map<dynamic, dynamic> credentials, this.sheetId})
      : api = gsheets.GSheets(credentials);

  final gsheets.GSheets api;
  final String sheetId;
  gsheets.Spreadsheet _spreadsheet;
  Map<County, Map<Town, List<EdAction>>>
      _data; // cannot dynamically query so must be loaded

  Future<gsheets.Spreadsheet> get spreadsheet async {
    if (_spreadsheet != null) {
      return _spreadsheet;
    }
    return _spreadsheet = await api.spreadsheet(sheetId);
  }

  @override
  Future<List<EdAction>> getActions(County county, Town town) async {
    if (_data[county][town] != null) {
      return _data[county][town];
    }
    await getTowns(county); // also gets actions
    return _data[county][town];
  }

  @override
  List<County> getCounties() => County.values;

  @override
  Future<List<Town>> getTowns(County county) async {
    if (_data.containsKey(county)) {
      return _data[county].keys.toList();
    }
    _data[county] = <Town, List<EdAction>>{};
    final LinkedHashMap<String, List<EdAction>> towns =
        LinkedHashMap<String, List<EdAction>>();

    final Map<String, String> townZipcodes = <String, String>{};
    final List<EdAction> countyActions = <EdAction>[];

    for (final List<String> row in await (await spreadsheet)
        .worksheetByTitle(county.name.toLowerCase())
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
        debugPrint(e.toString());
      }
    }
    _data[county].addAll(
      towns.map<Town, List<EdAction>>(
        (String townName, List<EdAction> actions) =>
            MapEntry<Town, List<EdAction>>(
          Town(name: townName, zipcode: townZipcodes[townName]),
          actions + countyActions,
        ),
      ),
    );
    return _data[county].keys.toList();
  }
}
