import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

abstract class Api {
  Future<List<EdAction>> getActions(County county, Town town);
  Future<List<Town>> getTowns(County county);
  List<County> getCounties();
}
