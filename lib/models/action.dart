import 'package:meta/meta.dart';
import 'package:jiffy/jiffy.dart';

enum ActionType {
  Grant,
  Letter,
  Endorsement,
  Legislation,
  Action,
  Other,
}

extension StringExtension on ActionType {
  String get name => this.toString().split('.').last;
}

extension ActionTypeExtension on String {
  ActionType get action => ActionType.values
      .firstWhere((element) => element.name == this, orElse: () => null);
}

class EdAction {
  final Jiffy date;
  final ActionType actionType;
  final String description;
  final int funding;
  final String url;

  EdAction({this.date, @required this.actionType, @required this.description, this.funding, this.url});
}
