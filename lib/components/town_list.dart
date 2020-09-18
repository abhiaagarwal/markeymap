import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:markeymap/components/action_card.dart';
import 'package:markeymap/components/loading.dart';
import 'package:markeymap/data/database.dart';
import 'package:markeymap/localization.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';
import 'package:markeymap/popup.dart';
import 'package:markeymap/utils/string.dart';

class TownList extends StatefulWidget {
  const TownList({@required this.county, Key key}) : super(key: key);

  final County county;

  @override
  _TownListState createState() => _TownListState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(EnumProperty<County>('county', county));
    super.debugFillProperties(properties);
  }
}

class _TownListState extends State<TownList> {
  Future<List<Town>> _towns;

  @override
  void initState() {
    super.initState();
    _towns =
        Provider.of<Database>(context, listen: false).getTowns(widget.county);
  }

  @override
  Widget build(BuildContext context) => Title(
        title: MarkeyMapLocalizations.of(context)
            .countyName(widget.county.name.toCapitalize()),
        color: Theme.of(context).primaryColor,
        child: FutureLoader<List<Town>>(
          future: _towns,
          builder: (BuildContext context, List<Town> towns) {
            final ScrollController scrollController = ScrollController();
            return Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                itemExtent: 50,
                itemCount: towns.length,
                controller: scrollController,
                addRepaintBoundaries: false,
                itemBuilder: (BuildContext context, final int index) =>
                    ListTile(
                  title: Text(
                    towns[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => showPopup(
                    context,
                    scaffoldColor: Theme.of(context).primaryColor,
                    body: ActionCard(
                      town: towns[index],
                      county: widget.county,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
}
