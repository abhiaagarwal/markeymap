// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class YoutubeContainer extends StatefulWidget {
  const YoutubeContainer({
    this.title,
    @required this.url,
    @required this.height,
    @required this.width,
    Key key,
  }) : super(key: key);

  final String title;
  final String url;
  final double height;
  final double width;

  @override
  _YoutubeContainerState createState() => _YoutubeContainerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('url', url))
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('width', width));
    super.debugFillProperties(properties);
  }
}

class _YoutubeContainerState extends State<YoutubeContainer> {
  String _elementName;

  @override
  void initState() {
    _elementName = widget.title ?? widget.key.toString();
    final IFrameElement _iframeElement = IFrameElement()
      ..title = _elementName
      ..height = widget.height?.toString()
      ..width = widget.width?.toString()
      ..src = widget.url.contains('youtube.com')
          ? widget.url
          : 'https://www.youtube.com/embed/${widget.url}'
      ..style.border = 'none';

    ui.platformViewRegistry.registerViewFactory(
      _elementName,
      (int viewId) => _iframeElement,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: HtmlElementView(
        viewType: _elementName,
      ),
    );
  }
}
