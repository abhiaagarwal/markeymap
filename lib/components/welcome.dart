// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:markeymap/resources.dart';

// import 'package:video_player/video_player.dart';

/*
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
      MarkeyMapTheme.animationDuration,
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
      child: GestureDetector(
        onTap: () => _controller.play(),
        child: Center(
          child: VideoPlayer(_controller),
        ),
      ));
}
*/

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Provider.of<Resource>(context).images.texture),
          repeat: ImageRepeat.repeat,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final IFrameElement _iframeElement = IFrameElement()
      ..width = '560'
      ..height = '315'
      ..src = 'https://www.youtube.com/embed/mzBePgUCV4I'
      ..style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
    return Container(
      decoration: _decoration(context),
      child: const HtmlElementView(
        viewType: 'iframeElement',
      ),
    );
  }
}
