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
  ActionType get action => ActionType.values.firstWhere(
        (ActionType element) => element.name.toLowerCase() == toLowerCase(),
        orElse: () => null,
      );
}

class EdAction {
  final String date;
  final ActionType type;
  final String description;
  final double funding;
  final String url;

  const EdAction({
    this.date,
    @required this.type,
    @required this.description,
    this.funding,
    this.url,
  })  : assert(type != null),
        assert(description != null);

  EdAction.fromRow(List<String> row)
      : date = row[1].isNotEmpty ? row[1] : null,
        type = row[2].action ?? ActionType.Other,
        description = row[3],
        funding = row[4].isNotEmpty ? double.tryParse(row[4]) : null,
        url = row[5].isNotEmpty ? row[5] : null;
}
