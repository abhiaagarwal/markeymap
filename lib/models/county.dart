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
  Worchester,
}

extension NameExtension on County {
  String get name => toString().split('.').last;
}

extension CountyExtension on String {
  County get county => County.values
      .firstWhere((County element) => element.name == this, orElse: () => null);
}