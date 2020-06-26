import 'package:markeymap/models/action.dart';

import 'package:meta/meta.dart';

class Town {
  String name;
  List<EdAction> actions;
  Town({@required this.name, @required this.actions});

  double get totalFundraised => actions.fold<double>(0, (double p, EdAction c) => p + c.funding);
}