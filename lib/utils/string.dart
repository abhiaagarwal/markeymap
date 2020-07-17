
extension CapitalizeExtension on String {
  String toCapitalize() => this[0].toUpperCase() + substring(1);
}