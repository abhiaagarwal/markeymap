import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

import 'package:markeymap/data/api.dart';

class Database with Diagnosticable {
  Database({this.api, Map<County, Map<Town, List<EdAction>>> initialData})
      : _data = initialData ?? <County, Map<Town, List<EdAction>>>{};

  final Api api;
  final Map<County, Map<Town, List<EdAction>>> _data;

  UnmodifiableMapView<County, Map<Town, List<EdAction>>> get data =>
      UnmodifiableMapView<County, Map<Town, List<EdAction>>>(_data);

  Future<SplayTreeMap<Town, County>> townsByCounty() async {
    await loadAllTowns();
    final SplayTreeMap<Town, County> map = SplayTreeMap<Town, County>();
    for (final MapEntry<County, Map<Town, List<EdAction>>> entry
        in data.entries) {
      for (final Town town in entry.value.keys) {
        map[town] = entry.key;
      }
    }
    return map;
  }

  Future<List<EdAction>> getActions(County county, Town town) async =>
      _data[county][town] ??= await api.getActions(county, town);

  Future<List<Town>> getTowns(County county) async => (_data[county] ??=
          (await api.getTowns(county)).asMap().map<Town, List<EdAction>>(
                (int key, Town value) =>
                    MapEntry<Town, List<EdAction>>(value, null),
              ))
      .keys
      .toList();

  List<County> getCounties() => api.getCounties();

  Future<void> loadAllTowns() async {
    for (final County county in api.getCounties()) {
      await getTowns(county);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(StringProperty('api', api.toString()))
      ..add(DiagnosticsProperty<
          UnmodifiableMapView<County, Map<Town, List<EdAction>>>>(
        'data',
        data,
      ));
    super.debugFillProperties(properties);
  }
}
