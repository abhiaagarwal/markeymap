import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  String get title => Intl.message(
        'Markey Map',
        name: 'title',
        desc: 'App Title',
      );

  String get searchBar => Intl.message(
        'Search your town, city, or county to find out what Ed has done for your community',
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

  String totalSecured(double amount) => Intl.message('Total Secured: $amount',
      name: 'totalSecured',
      args: <Object>[amount],
      desc: 'Amount of money secured for a community',
      examples: const <String, double>{
        'amount': 120000.00,
      });

  String get info => Intl.message(
        'Info',
        name: 'info',
        desc: 'Information Button',
      );

  String get otherAccomplishments => Intl.message(
        'Other Accomplishments',
        name: 'otherAccomplishments',
        desc: 'Other Accomplishmnets outside of Counties button',
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
}

class MarkeyMapLocalizationsDelegate
    extends LocalizationsDelegate<MarkeyMapLocalizations> {
  const MarkeyMapLocalizationsDelegate();

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
