import 'package:markeymap/models/action.dart';

class Town {
  String name;
  List<EdAction> actions;
  Town(this.name, this.actions);

  int get totalFundraised => actions.fold(0, (int p, EdAction c) => p + c.funding);
}