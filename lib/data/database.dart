import 'package:flutter/foundation.dart';

import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

abstract class Database extends ChangeNotifier {

  List<EdAction> getActions(Town town);
  List<County> getCounties();
  List<Town> getTowns(County county);
}