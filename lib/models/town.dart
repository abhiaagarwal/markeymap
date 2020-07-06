import 'package:markeymap/models/action.dart';

import 'package:meta/meta.dart';

class Town {
  final String name;
  final List<EdAction> actions;
  final int zipcode;
  const Town({@required this.name, @required this.actions, this.zipcode});

  double get totalSecured => actions.fold<double>(0, (double p, EdAction c) => p + c.funding ?? 0);
}