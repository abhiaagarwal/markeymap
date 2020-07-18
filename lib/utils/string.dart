extension CapitalizeExtension on String {
  String toCapitalize() {
    try {
      return split(' ')
          .map((String part) => part[0].toUpperCase() + part.substring(1))
          .join(' ');
    } on Exception {
      return this[0].toUpperCase() + substring(1);
    }
  }
}
