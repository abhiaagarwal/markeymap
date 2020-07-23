import 'package:flutter/foundation.dart';
import 'package:markeymap/models/action.dart';

class Town with DiagnosticableTreeMixin {
  final String name;
  final String zipcode;
  final List<EdAction> actions;
  const Town(
      {@required this.name, @required this.actions, @required this.zipcode})
      : assert(name != null),
        assert(zipcode != null);

  Town.fromMap(Map<String, dynamic> data)
      : name = data['name'] as String,
        actions = (data['actions'] as List<Map<String, dynamic>>)
            .map<EdAction>(
                (Map<String, dynamic> action) => EdAction.fromMap(action))
            .toList(),
        zipcode = data['zipcode'] as String;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'actions': actions
            .map<Map<String, dynamic>>((EdAction action) => action.toMap())
            .toList(),
        'zipcode': zipcode,
      };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('name', name))
      ..add(IterableProperty<EdAction>('actions', actions))
      ..add(StringProperty('zipcode', zipcode));
  }
}
