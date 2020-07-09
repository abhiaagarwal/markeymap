import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:markeymap/theme.dart';

class Loading extends StatefulWidget {
  const Loading({Key key}) : super(key: key);

  static const List<String> funFacts = <String>[
    'Ed is hot and sexy',
    'Ed does cool things too',
    'hiii ed markey hiiii ',
  ];

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Timer _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () => _index = Random(timer.tick).nextInt(Loading.funFacts.length),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) => Material(
    child: Container(
      width: double.infinity,
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              Text(
                'Did you know: ${Loading.funFacts[_index]}',
                style:
                    MarkeyMapTheme.searchBarStyle.copyWith(color: Colors.black),
              ),
            ],
          ),
    ),
  );
}
