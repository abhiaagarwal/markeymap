enum County {
  Barnstable,
  Berkshire,
  Bristol,
  Dukes,
  Essex,
  Franklin,
  Hampden,
  Hampshire,
  Nantucket,
  Middlesex,
  Norfolk,
  Plymouth,
  Suffolk,
  Worcester,
  Other,
}

extension NameExtension on County {
  String get name => toString().split('.').last;
}

extension CountyExtension on String {
  County get county => County.values
      .firstWhere((County element) => element.name.toLowerCase() == toLowerCase(), orElse: () => null);
}