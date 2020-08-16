import 'package:flutter/foundation.dart';

enum County {
  barnstable,
  berkshire,
  bristol,
  dukes,
  essex,
  franklin,
  hampden,
  hampshire,
  nantucket,
  middlesex,
  norfolk,
  plymouth,
  suffolk,
  worcester,
  other,
}

extension NameExtension on County {
  String get name => describeEnum(this);
}

extension CountyExtension on String {
  County get county => County.values.firstWhere(
        (County element) => element.name.toLowerCase() == toLowerCase(),
        orElse: () => null,
      );
}
