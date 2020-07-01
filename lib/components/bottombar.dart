import 'package:flutter/material.dart';

import 'package:markeymap/theme.dart';

class BottomBar extends StatelessWidget implements PreferredSizeWidget {
  const BottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _BottomButton(
              text: 'Info',
              color: Colors.red,
            ),
            _BottomButton(
              text: 'Statewide Accomplishments',
              color: Colors.blue,
            ),
            _BottomButton(
              text: 'Donate',
              color: Colors.green,
            ),
            _BottomButton(
              text: 'Join us',
              color: Colors.yellow,
            ),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _BottomButton extends StatelessWidget {
  final String text;
  final Function function;
  final Color color;
  const _BottomButton(
      {@required this.text, @required this.function, this.color, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      RaisedButton(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        color: color, 
        child: Text(
          text.toUpperCase(),
          style: MarkeyMapTheme.buttonStyle,
        ),
        onPressed: () => function(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )
      );
}
