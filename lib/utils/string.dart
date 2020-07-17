extension CapitalizeExtension on String {
  String toCapitalize() => split(' ')
      .map((String part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}
