import 'package:flutter/material.dart';

void showPopup(
  BuildContext context, {
  @required Widget widget,
  @required String title,
  Color scaffoldColor,
}) =>
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            backgroundColor: scaffoldColor,
            appBar: AppBar(
              title: Text(title),
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomInset: false,
            body: widget,
          ),
        ),
      ),
    );

class PopupLayout extends ModalRoute<void> {
  final double top;
  final double bottom;
  final double left;
  final double right;
  final Color backgroundColor;
  final Widget child;

  PopupLayout({
    this.backgroundColor,
    @required this.child,
    this.top = 10,
    this.bottom = 20,
    this.left = 20,
    this.right = 20,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => backgroundColor ?? Colors.black.withOpacity(0.5);
  @override
  String get barrierLabel => null;
  @override
  bool get maintainState => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      GestureDetector(
        /*
      onTap: () {
        // call this method here to hide soft keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },*/
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            bottom: true,
            child: _buildOverlayContent(context),
          ),
        ),
      );

  Widget _buildOverlayContent(BuildContext context) => Container(
        margin: EdgeInsets.only(
          bottom: bottom,
          left: left,
          right: right,
          top: top,
        ),
        child: child,
      );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
}

class PopupContent extends StatefulWidget {
  final Widget content;
  const PopupContent({
    Key key,
    this.content,
  }) : super(key: key);

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        child: widget.content,
      );
}
