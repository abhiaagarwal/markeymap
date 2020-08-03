import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:markeymap/app.dart';
import 'package:markeymap/resources.dart';
import 'package:markeymap/data/api.dart';
import 'package:markeymap/data/firebase/firebase.dart';
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
        Provider<Api>(
          create: (BuildContext context) => FirebaseApi(),
        ),
        ProxyProvider<Api, Database>(
          update: (BuildContext context, Api api, Database database) =>
              Database(api: api),
        )
      ],
      child: const MarkeyMapApp(),
    ),
  );
}
