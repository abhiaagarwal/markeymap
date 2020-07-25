import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:markeymap/app.dart';
import 'package:markeymap/resources.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(
      MultiProvider(
        providers: <SingleChildWidget>[
          Provider<Resource>(
            create: (BuildContext context) => const Resource(),
          ),
          Provider<FirebaseAnalytics>(
            create: (BuildContext context) => FirebaseAnalytics(),
            lazy: false,
          ),
        ],
        child: const MarkeyMapApp(),
      ),
    );
