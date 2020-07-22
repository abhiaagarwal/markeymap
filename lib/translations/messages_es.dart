// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static m0(county) => "Condado de ${county}";

  static m1(amount) => "Total de fondos asegurados: ${amount}";

  static m2(town) => "Ayuda a Ed a luchar por ${town}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "countyName" : m0,
    "didYouKnow" : MessageLookupByLibrary.simpleMessage("¿Sabías que?"),
    "donate" : MessageLookupByLibrary.simpleMessage("Donaciones"),
    "getInvolved" : MessageLookupByLibrary.simpleMessage("Involúcrate"),
    "navigate" : MessageLookupByLibrary.simpleMessage("Cómo navegar"),
    "searchBar" : MessageLookupByLibrary.simpleMessage("Aprenda qué ha hecho senador Ed Markey para tu comunidad con nuestro Markey Map"),
    "statewideAccomplishments" : MessageLookupByLibrary.simpleMessage("Statewide Accomplishments"),
    "title" : MessageLookupByLibrary.simpleMessage("Markey Map"),
    "totalSecured" : m1,
    "townCTA" : m2,
    "volunteer" : MessageLookupByLibrary.simpleMessage("Involúcrate")
  };
}
