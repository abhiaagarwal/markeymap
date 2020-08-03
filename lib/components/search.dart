import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:markeymap/components/action_card.dart';
import 'package:markeymap/components/loading.dart';
import 'package:markeymap/data/database.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';
import 'package:markeymap/popup.dart';
import 'package:markeymap/utils/string.dart';

Future<void> handleSearch(BuildContext context) async {
  final MapEntry<Town, County> entry = await showSearch<MapEntry<Town, County>>(
    context: context,
    delegate: TownSearchDelegate(),
  );
  if (entry == null) {
    return;
  }
  showPopup(
    context,
    scaffoldColor: Theme.of(context).primaryColor,
    body: ActionCard(town: entry.key, county: entry.value),
  );
}

class TownSearchDelegate extends SearchDelegate<MapEntry<Town, County>> {
  SplayTreeMap<Town, County> _towns;
  TownSearchDelegate();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_towns == null) {
      return FutureLoader<SplayTreeMap<Town, County>, Widget>(
        future: Provider.of<Database>(context, listen: false).townsByCounty,
        builder: (BuildContext context, SplayTreeMap<Town, County> towns) {
          _towns = towns;
          return _searchResults(context, towns);
        },
      );
    }
    return _searchResults(context, _towns);
  }

  Widget _searchResults(
      BuildContext context, SplayTreeMap<Town, County> towns) {
    final Map<Town, County> results = Map<Town, County>.from(towns)
      ..removeWhere((Town key, County value) =>
          !key.name.toLowerCase().contains(query.toLowerCase()));
    return Title(
      title: 'Search',
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        itemExtent: 60,
        itemCount: results.length,
        itemBuilder: (BuildContext context, final int index) {
          final MapEntry<Town, County> entry = results.entries.elementAt(index);
          return ListTile(
            title: Text(entry.key.name),
            subtitle: Text(entry.value.name.toCapitalize()),
            onTap: () => close(context, entry),
          );
        },
      ),
    );
  }
}
