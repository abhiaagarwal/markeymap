import 'package:markeymap/models/action.dart';

import 'package:meta/meta.dart';

class Town {
  String name;
  List<EdAction> actions;
  Town({@required this.name, @required this.actions});

  int get totalFundraised => actions.fold(0, (int p, EdAction c) => p + c.funding);
}