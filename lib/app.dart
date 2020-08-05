import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:markeymap/components/appbar.dart';
import 'package:markeymap/components/bottombar.dart';
import 'package:markeymap/components/map.dart';
import 'package:markeymap/localization.dart';
import 'package:markeymap/theme.dart';
import 'package:provider/provider.dart';

class MarkeyMapApp extends StatelessWidget {
  const MarkeyMapApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(
            analytics: Provider.of<FirebaseAnalytics>(context),
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
        home: const MarkeyScaffold(),
      );
}

class MarkeyScaffold extends StatelessWidget {
  const MarkeyScaffold({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const MainAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: InteractiveViewer(
            minScale: 1,
            boundaryMargin: const EdgeInsets.all(32),
            child: const Center(
              child: FittedBox(
                child: InteractiveMap(),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(),
      );
}
