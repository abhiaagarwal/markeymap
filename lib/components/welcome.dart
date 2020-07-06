import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'package:markeymap/theme.dart';
import 'package:markeymap/popup.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.info),
        onPressed: () => showPopup(
          context,
          body: const WelcomeScreen(),
          scaffoldColor: Theme.of(context).accentColor,
        ),
      );
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/intro_video.mp4')
      ..initialize()
      ..setLooping(true)
      ..play();
  }

  BoxDecoration get _decoration => const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/texture.png'),
          repeat: ImageRepeat.repeat,
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: _decoration,
        child: Center(
          child: VideoPlayer(_controller),
        ),
      );
}
