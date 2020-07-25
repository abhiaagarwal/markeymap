import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gsheets/gsheets.dart' as sheets;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:markeymap/resources.dart' as resources;
import 'package:markeymap/theme.dart';
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

  /*
  Future<void> _preloadSVGs(
      BuildContext context, List<String> townNames) async {
    for (final String name in townNames) {
      // ignore: unawaited_futures
      precachePicture(
        SvgPicture.asset(
          '${resources.SVG.townSvg}${name.trim().replaceAll(' ', '-')}.svg',
          bundle: DefaultAssetBundle.of(context),
        ).pictureProvider,
        context,
      );
    }
  }
  */

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

      /*
      // ignore: unawaited_futures
      compute<List<String>, void>(
        (List<String> townNames) => _preloadSVGs(context, townNames),
        towns.keys.toList(),
      );
      */

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

    /*
    print('Converting Google Sheets Data to Firebase');
    FirebaseFirestore store = FirebaseFirestore.instance;
    for (County county in countiesList.keys) {
      CollectionReference reference =
          store.collection(county.name.toLowerCase());
      for (Town town in countiesList[county]) {
        reference.doc(town.name.toLowerCase()).set(<String, dynamic>{
          'zipcode': town.zipcode,
          'actions': town.actions.map<Map<String, dynamic>>(
            (EdAction action) => <String, dynamic>{
              'date': action.date,
              'description': action.description,
              'type': action.type.name.toLowerCase(),
              'link': action.url,
              'funding': action.funding,
            },
          ),
        });
      }
    }
    */
    /*
    final FirebaseFirestore store = FirebaseFirestore.instance;
    try {
      await store.enablePersistence();
    } catch (e) {
      print(e);
    }
    Map<County, List<Town>> countiesList = <County, List<Town>>{
      for (final County county in County.values)
        county: (await store.collection(county.name.toLowerCase()).get())
            .docs
            .map<Town>(
              (QueryDocumentSnapshot document) => Town.fromMap(
                document.data()
                  ..addAll(
                    <String, String>{'name': document.id},
                  ),
              ),
            )
            .toList(),
    }..forEach(
        (County county, List<Town> towns) => compute<List<String>, void>(
          (List<String> townNames) => _preloadSVGs(context, townNames),
          towns.map<String>((Town town) => town.name).toList(),
        ),
      );*/
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<County, List<Town>>>(
        future: _data(context),
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<County, List<Town>>> snapshot,
        ) =>
            AnimatedSwitcher(
          duration: MarkeyMapTheme.animationDuration,
          child: () {
            compute(
              (dynamic _) => precacheImage(
                AssetImage(
                  resources.Image.header,
                  bundle: DefaultAssetBundle.of(context),
                ),
                context,
              ),
              null,
            );
            compute(
              (dynamic _) => precacheImage(
                AssetImage(
                  resources.Image.logo,
                  bundle: DefaultAssetBundle.of(context),
                ),
                context,
              ),
              null,
            );
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return MarkeyMapData(
                    key: const ValueKey<int>(2),
                    data: snapshot.data,
                    child: child,
                  );
                } else {
                  return Container(
                    key: const ValueKey<int>(3),
                    child: const Center(
                      child: Text(
                        'Thank you so much for visiting. The Markey Map is experiencing high volume. Please Refresh.',
                        style: MarkeyMapTheme.funFactStyle,
                      ),
                    ),
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
