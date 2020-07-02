import 'package:meta/meta.dart';

enum ActionType {
  Grant,
  Letter,
  Endorsement,
  Legislation,
  Action,
  Other,
}

extension StringExtension on ActionType {
  String get name => toString().split('.').last;
}

extension ActionTypeExtension on String {
  ActionType get action => ActionType.values
      .firstWhere((ActionType element) => element.name == this, orElse: () => null);
}

class EdAction {
  final String date;
  final ActionType type;
  final String description;
  final double funding;
  final String url;

  EdAction({this.date, @required this.type, @required this.description, this.funding, this.url});
}
