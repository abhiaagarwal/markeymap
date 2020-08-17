import 'package:flutter/widgets.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:markeymap/app.dart';
import 'package:markeymap/resources.dart';
import 'package:markeymap/data/api.dart';
//import 'package:markeymap/data/firebase/firebase.dart';
import 'package:markeymap/data/sheets/gsheets.dart';
import 'package:markeymap/data/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider<Resource>(
          create: (BuildContext context) => const Resource(),
        ),
        Provider<FirebaseAnalytics>(
          create: (BuildContext context) => FirebaseAnalytics(),
          lazy: false,
        ),
        /*
        Provider<Api>(
          create: (BuildContext context) => FirebaseApi(),
        ),
        */
        FutureProvider<Api>(
          initialData: null,
          lazy: false,
          create: (BuildContext context) async => GSheetsApi(
            sheetId: '18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ',
            credentials: await DefaultAssetBundle.of(context)
                .loadString('assets/credentials.json'),
          ),
        ),
        ProxyProvider<Api, Database>(
          update: (BuildContext context, Api api, Database database) =>
              Database(api: api),
        ),
      ],
      child: const MarkeyMapApp(),
    ),
  );
}
