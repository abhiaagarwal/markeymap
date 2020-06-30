import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:markeymap/data.dart';
import 'package:markeymap/popup.dart';
import 'package:markeymap/components/town_card.dart';
import 'package:markeymap/models/town.dart';
import 'package:markeymap/models/county.dart';

Future<void> handleSearch(BuildContext context) async {
  final MapEntry<Town, County> town = await showSearch<MapEntry<Town, County>>(
    context: context,
    delegate: TownSearchDelegate(MarkeyMapData.of(context).townsByCounty),
  );
  if (town == null) {
    return;
  }
  showPopup(
    context,
    scaffoldColor: Theme.of(context).primaryColor,
    body: TownCard(
      town: town.key,
      countyName: town.value.name,
    ),
  );
}

class SearchButton extends StatelessWidget {
  const SearchButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => handleSearch(context),
      );
}

class TownSearchDelegate extends SearchDelegate<MapEntry<Town, County>> {
  final SplayTreeMap<Town, County> towns;
  TownSearchDelegate(this.towns);

  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final Map<Town, County> results = Map<Town, County>.from(towns)
      ..removeWhere((Town key, County value) =>
          !key.name.toLowerCase().contains(query.toLowerCase()));
    return Title(
      title: 'Search',
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        itemExtent: 60.0,
        itemCount: results.length,
        itemBuilder: (BuildContext context, final int index) {
          final MapEntry<Town, County> entry = results.entries.elementAt(index);
          return ListTile(
            title: Text(entry.key.name),
            subtitle: Text(entry.value.name),
            onTap: () => close(context, entry),
          );
        },
      ),
    );
  }
}
