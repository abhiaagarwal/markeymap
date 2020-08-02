// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  String lookupMessage(
      String message_str,
      String locale,
      String name,
      List<dynamic> args,
      String meaning,
      {MessageIfAbsent ifAbsent}) {
    String failedLookup(String message_str, List<dynamic> args) {
      // If there's no message_str, then we are an internal lookup, e.g. an
      // embedded plural, and shouldn't fail.
      if (message_str == null) return null;
      throw new UnsupportedError(
          "No translation found for message '$name',\n"
          "  original text '$message_str'");
    }
    return super.lookupMessage(message_str, locale, name, args, meaning,
        ifAbsent: ifAbsent ?? failedLookup);
  }

  static m0(county) => "${county} County";

  static m1(amount) => "Total Secured: ${amount}";

  static m2(town) => "Help Ed fight for ${town}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "countyName" : m0,
    "didYouKnow" : MessageLookupByLibrary.simpleMessage("Did you know?"),
    "donate" : MessageLookupByLibrary.simpleMessage("Donate"),
    "getInvolved" : MessageLookupByLibrary.simpleMessage("Get Involved"),
    "navigate" : MessageLookupByLibrary.simpleMessage("How to Navigate"),
    "returnText" : MessageLookupByLibrary.simpleMessage("Return to EdMarkey.com"),
    "searchBar" : MessageLookupByLibrary.simpleMessage("Search your town, city, or county to see how Ed Markey has delivered for your community"),
    "statewideAccomplishments" : MessageLookupByLibrary.simpleMessage("Statewide Accomplishments"),
    "title" : MessageLookupByLibrary.simpleMessage("Markey Map"),
    "totalSecured" : m1,
    "townCTA" : m2,
    "volunteer" : MessageLookupByLibrary.simpleMessage("Volunteer")
  };
}
