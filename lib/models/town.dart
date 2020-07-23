import 'package:flutter/foundation.dart';

class Town with DiagnosticableTreeMixin {
  final String name;
  final String zipcode;
  const Town({@required this.name, @required this.zipcode})
      : assert(name != null),
        assert(zipcode != null);

  Town.fromMap(Map<String, dynamic> data)
      : name = data['name'] as String,
        zipcode = data['zipcode'] as String;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'zipcode': zipcode,
      };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('name', name))
      ..add(StringProperty('zipcode', zipcode));
  }
}
