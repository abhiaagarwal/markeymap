import 'package:flutter/foundation.dart';

enum ActionType {
  grant,
  letter,
  endorsement,
  legislation,
  action,
  other,
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

class EdAction with DiagnosticableTreeMixin {
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
        type = row[2].action ?? ActionType.other,
        description = row[3],
        funding = row[4].isNotEmpty ? double.tryParse(row[4]) : null,
        url = row[5].isNotEmpty ? row[5] : null;

  EdAction.fromMap(Map<String, dynamic> data)
      : date = data['date'] as String,
        type = (data['type'] as String).action ?? ActionType.other,
        description = data['description'] as String,
        funding = data['funding'] as double,
        url = data['url'] as String;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'date': date,
        'type': type.name,
        'description': description,
        'funding': funding.toString(),
        'url': url,
      };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('date', date))
      ..add(EnumProperty<ActionType>('type', type))
      ..add(StringProperty('description', description))
      ..add(DoubleProperty('funding', funding))
      ..add(StringProperty('url', url));
  }
}

extension TotalSecuredExtension on List<EdAction> {
  double get totalSecured =>
      fold<double>(0, (double p, EdAction e) => p + (e.funding ?? 0));
}
