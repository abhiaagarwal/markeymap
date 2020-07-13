import 'package:flutter/material.dart';

import 'package:markeymap/resources.dart' as resources;

import 'package:video_player/video_player.dart';

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
    _controller = VideoPlayerController.asset(resources.Video.introVideo)
      ..initialize()
      ..setLooping(true);
    Future<void>.delayed(
      const Duration(milliseconds: 300),
      () => _controller.play(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  BoxDecoration get _decoration => const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(resources.Image.texture),
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
