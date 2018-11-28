import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureCard extends StatelessWidget {
  final Temperature _temperature;

  TemperatureCard(this._temperature);

  @override
  Widget build(BuildContext context) {
    return new CustomCard(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${_temperature.temperature} °C",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Icon(
                FontAwesomeIcons.thermometerHalf,
                color: Colors.black,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              _temperature.sensorID,
              style: TextStyle(color: Colors.grey),
            ),
            Container(
              child: Icon(
                Icons.wifi_tethering,
                color: Colors.grey,
              ),
              margin: EdgeInsets.only(left: 5, bottom: 10),
            )
          ],
        )
      ],
    ));
  }
}
