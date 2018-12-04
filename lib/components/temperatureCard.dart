import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pooltemp_flutter/model/sensor.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureCard extends StatelessWidget {
  final Temperature _temperature;

  final Sensor _sensor;

  TemperatureCard(this._temperature, this._sensor);

  @override
  Widget build(BuildContext context) {
    return new CustomCard(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${_temperature.temperature.toStringAsFixed(2)} °C",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Icon(
                  FontAwesomeIcons.thermometerHalf,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(_sensor.name!=null?_sensor.name.trim():_sensor.id.trim(),
                style: TextStyle(color: Colors.grey),
              ),
              Container(
                child: Icon(
                  Icons.wifi_tethering,
                  color: Colors.grey,
                ),
                margin: EdgeInsets.only(left: 5),
              )
            ],
          ),
        )
      ],
    ));
  }
}
