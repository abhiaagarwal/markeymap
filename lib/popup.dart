import 'package:flutter/material.dart';

void showPopup(
  BuildContext context, {
  @required Widget body,
  String title,
  Color scaffoldColor,
}) =>
    Navigator.push(
      context,
      PopupLayout(
        child: Scaffold(
          backgroundColor: scaffoldColor,
          appBar: AppBar(
            title: Text(title ?? ''),
            leading: Builder(
              builder: (BuildContext context) => IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: body,
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
    this.top = 30,
    this.bottom = 50,
    this.left = 30,
    this.right = 30,
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
      Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
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
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
}
