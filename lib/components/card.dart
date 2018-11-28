import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: double.infinity,
      child: new Card(
        color: Colors.white,
        elevation: 5,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Container(alignment: Alignment(0, 0), child: child),
      ),
    );
  }
}
