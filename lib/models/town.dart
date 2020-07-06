import 'package:markeymap/models/action.dart';

import 'package:meta/meta.dart';

class Town {
  final String name;
  final List<EdAction> actions;
  final String zipcode;
  const Town({@required this.name, @required this.actions, this.zipcode});

  double get totalSecured => actions.fold<double>(0, (double p, EdAction c) => p ?? 0 + c.funding ?? 0);
}