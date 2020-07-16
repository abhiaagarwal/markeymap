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
  String get name => toString().split('.').last;
}

extension CountyExtension on String {
  County get county => County.values
      .firstWhere((County element) => element.name == this, orElse: () => null);
}