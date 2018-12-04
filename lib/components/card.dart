import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({this.child, this.margin});

  final Widget child;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        color: Colors.white,
        elevation: 5,
        margin: margin ?? EdgeInsets.only(left: 20, right: 20),
        child: Container(alignment: Alignment(0, 0), child: child),
      ),
    );
  }
}
