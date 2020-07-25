import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:markeymap/components/appbar.dart';
import 'package:markeymap/components/bottombar.dart';
import 'package:markeymap/components/map.dart';
import 'package:markeymap/data.dart';
import 'package:markeymap/localization.dart';
import 'package:markeymap/resources.dart' as resources;
import 'package:markeymap/theme.dart';

void main() => runApp(const MarkeyMapApp());

class MarkeyMapApp extends StatelessWidget {
  const MarkeyMapApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics(),
          ),
        ],
        onGenerateTitle: (BuildContext context) =>
            MarkeyMapLocalizations.of(context).title,
        theme: MarkeyMapTheme.theme,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          MarkeyMapLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: MarkeyMapLocalizations.supportedLocales,
        home: const MarkeyMapBuilder(
          credentialsFile: resources.Data.credentials,
          sheetId: '18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ',
          child: MarkeyScaffold(),
        ),
      );
}

class MarkeyScaffold extends StatelessWidget {
  const MarkeyScaffold({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: MainAppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: FittedBox(
              child: InteractiveMap(),
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(),
      );
}
