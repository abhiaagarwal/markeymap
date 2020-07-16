import 'package:markeymap/models/action.dart';

import 'package:meta/meta.dart';

class Town {
  final String name;
  final List<EdAction> actions;
  final String zipcode;
  const Town({@required this.name, @required this.actions, this.zipcode})
      : assert(name != null),
        assert(actions != null);

  double get totalSecured => actions.fold<double>(
      0, (double p, EdAction e) => p + (e.funding ?? 0));
}
