import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:markeymap/theme.dart';

class Loading extends StatefulWidget {
  const Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Timer _timer;
  int _index;
  Random _random;

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
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Did you know? ',
                  style: MarkeyMapTheme.funFactStyle,
                  children: <TextSpan>[
                    TextSpan(
                      text: funFacts[_index],
                      style: MarkeyMapTheme.funFactStyle.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
