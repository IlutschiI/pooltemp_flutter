import 'package:flutter/material.dart';

class DateButton extends StatelessWidget {

  final VoidCallback onTap;
  final String text;
  final Color color;

  const DateButton({ this.onTap, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.5),
      child: RaisedButton(
        color: color,
        child: Text(text),
        onPressed: onTap,
      ),
    );
  }
}
