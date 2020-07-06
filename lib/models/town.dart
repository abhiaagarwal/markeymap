import 'package:markeymap/models/action.dart';

import 'package:meta/meta.dart';

class Town {
  String name;
  List<EdAction> actions;
  int zipcode;
  Town({@required this.name, @required this.actions, this.zipcode});

  double get totalSecured => actions.fold<double>(0, (double p, EdAction c) => p + c.funding ?? 0);
}