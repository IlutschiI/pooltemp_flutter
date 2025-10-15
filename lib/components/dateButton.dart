import 'package:flutter/material.dart';

class DateButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color color;

  const DateButton({this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.5),
      child: ElevatedButton(
        child: Text(text),
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
        onPressed: onTap,
      ),
    );
  }
}
