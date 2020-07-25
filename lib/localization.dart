import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:markeymap/translations/messages_all.dart';

class MarkeyMapLocalizations {
  static Future<MarkeyMapLocalizations> load(Locale locale) async {
    final String localeName = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);
    await initializeMessages(canonicalLocaleName);
    await initializeDateFormatting(canonicalLocaleName);
    Intl.defaultLocale = canonicalLocaleName;
    return MarkeyMapLocalizations();
  }

  static MarkeyMapLocalizations of(BuildContext context) =>
      Localizations.of<MarkeyMapLocalizations>(context, MarkeyMapLocalizations);

  static const _MarkeyMapLocalizationsDelegate delegate =
      _MarkeyMapLocalizationsDelegate();

  static List<Locale> get supportedLocales =>
      _MarkeyMapLocalizationsDelegate.supportedLocales;

  String get title => Intl.message(
        'Markey Map',
        name: 'title',
        desc: 'App Title',
      );

  String get searchBar => Intl.message(
        // ignore: lines_longer_than_80_chars
        'Search your town, city, or county to see how Ed Markey has delivered for your community',
        name: 'searchBar',
        desc: 'Place to search for communities',
      );

  String countyName(String county) => Intl.message(
        '$county County',
        name: 'countyName',
        args: <Object>[county],
        desc: 'Proper way to display County',
        examples: const <String, String>{
          'countyName': 'Essex',
        },
      );

  String totalSecured(double amount) => Intl.message(
        'Total Secured: $amount',
        name: 'totalSecured',
        args: <Object>[amount],
        desc: 'Amount of money secured for a community',
        examples: const <String, double>{
          'amount': 120000.00,
        },
      );

  String get navigate => Intl.message(
        'How to Navigate',
        name: 'navigate',
        desc: 'How to Navigate Button',
      );

  String get statewideAccomplishments => Intl.message(
        'Statewide Accomplishments',
        name: 'statewideAccomplishments',
        desc: 'Statewide Accomplishmnets outside of Counties button',
      );

  String get donate => Intl.message(
        'Donate',
        name: 'donate',
        desc: 'Donate button',
      );

  String get volunteer => Intl.message(
        'Volunteer',
        name: 'volunteer',
        desc: 'Volunteer button',
      );

  String get getInvolved => Intl.message(
        'Get Involved',
        name: 'getInvolved',
        desc: 'Get involved button',
      );

  String townCTA(String town) => Intl.message(
        'Help Ed fight for $town',
        name: 'townCTA',
        args: <Object>[town],
        desc: 'Call-to-Action to Donate',
        examples: const <String, String>{
          'town': 'Andover',
        },
      );

  String get didYouKnow => Intl.message(
        'Did you know?',
        name: 'didYouKnow',
        desc: 'Did you know text for loading page',
      );

  String get returnText => Intl.message(
        'Return to EdMarkey.com',
        name: 'returnText',
        desc: 'Text that returns you to EdMarkey.com',
      );
}

class _MarkeyMapLocalizationsDelegate
    extends LocalizationsDelegate<MarkeyMapLocalizations> {
  const _MarkeyMapLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en', 'US'),
    Locale('es'),
  ];

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  Future<MarkeyMapLocalizations> load(Locale locale) =>
      MarkeyMapLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<MarkeyMapLocalizations> old) => false;
}
