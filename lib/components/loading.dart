import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markeymap/localization.dart';
import 'package:markeymap/theme.dart';

class FutureLoader<T, W extends Widget> extends StatelessWidget {
  final W Function(BuildContext, T) builder;
  final Future<T> future;
  final T initialData;
  const FutureLoader(
      {@required this.builder,
      @required this.future,
      this.initialData,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: future,
        initialData: initialData,
        builder: (
          BuildContext context,
          AsyncSnapshot<T> snapshot,
        ) =>
            AnimatedSwitcher(
          duration: MarkeyMapTheme.animationDuration,
          child: () {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return Container();
              //toDo: add error handling
            }
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return Builder(
                    key: const ValueKey<int>(0),
                    builder: (BuildContext context) =>
                        builder(context, snapshot.data),
                  );
                } else {
                  debugPrint(snapshot.error.toString());
                  return Container();
                }
                break;
              default:
                return const Loading(key: ValueKey<int>(1));
            }
          }(),
        ),
      );
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.all(8),
          //color: Colors.white,
          width: double.infinity,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 30),
                //_DidYouKnow(),
              ],
            ),
          ),
        ),
      );
}

class _DidYouKnow extends StatefulWidget {
  const _DidYouKnow({Key key}) : super(key: key);

  @override
  _DidYouKnowState createState() => _DidYouKnowState();
}

class _DidYouKnowState extends State<_DidYouKnow> {
  Timer _timer;
  int _index;
  Random _random;

  // ignore_for_file: lines_longer_than_80_chars
  static const List<String> funFacts = <String>[
    'In 2006, Ed Markey successfully created an amendment that extended Daylight Savings Time',
    'Ed has been a leading voice against weapons of mass destruction since the 1970s, once speaking to a crowd of over 1 million people at the 1982 Nuclear Freeze Rally in New York City',
    'Ed Markey has championed environmental causes throughout his entire career, from the Public Recreation Area Recycling Incentives and Education Act in 1990 to the historic proposed Waxman-Markey Bill of 2009 to the landmark Green New Deal that he introduced with Rep. Alexandria Ocasio-Cortez in 2019',
    'In 1996, Ed was only one of 67 members of the House who voted against the Defense of Marriage Act',
    'Ed founded the Congressional Task Force on Alzheimer’s Disease in 1999 and is dedicated to finding a cure by 2025',
    'Ed mandated the use of accessibility measures like closed captioning in modern telecommunications with the 21st Century Communications and Video Accessibility Act',
    'In 2019, Ed helped secure \$25 million to fund CDC research on the root causes of gun violence as part of the Gun Violence Prevention Research Act, which was the first time Congress approved funding for research on this topic since 1996',
    'Ed Markey has been a leading advocate for children’s privacy throughout his career',
    'When he was a state representative in the early 1970s, Ed Markey fought to pass a major criminal justice overhaul bill—making statehouse leaders so mad, they threw his desk in the hall. This led to his famous line, “the bosses can tell me where to sit, but nobody can tell me where to stand.”',
    'Ed is a fan of wordplay and acronyms. Some of his favorites are “NRA - Not Relevant Anymore”, “EPA - End Our Petroleum Addictions”, “GOP - Gut Our Programs”, and “UPS - Unfair Part-time Servitude”',
  ];

  @override
  void initState() {
    super.initState();
    () async {
      await Future<void>.delayed(const Duration(seconds: 200), () => null);
    }();
    _random = Random();
    _index = _random.nextInt(funFacts.length);
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) => setState(
        () => _index = _random.nextInt(funFacts.length),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: MarkeyMapLocalizations.of(context).didYouKnow,
          style: MarkeyMapTheme.funFactStyle,
          children: <TextSpan>[
            const TextSpan(
              text: ' ',
            ),
            TextSpan(
              text: funFacts[_index],
              style: MarkeyMapTheme.funFactStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      );
}
