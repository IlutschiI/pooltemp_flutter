import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/components/temperatureCard.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  List<Temperature> _temperatures=new List();

  @override
  void initState() {
    _temperatures.add(new Temperature(sensorID: "000-212-34BD", temperature: 12.0));
    _temperatures.add(new Temperature(sensorID: "4A3-097-F3BC", temperature: 23.0));
  }

  void relaod(){
    setState(() {
      _temperatures[0].temperature++;
      _temperatures[1].temperature++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: relaod,
        child: Icon(Icons.refresh),
        elevation: 2.0,
      ),
      body: new Material(
        color: Colors.blueAccent,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _temperatures.map((t)=>Container(
            child: TemperatureCard(t),
            margin: EdgeInsets.only(top: 5),
          )).toList(),
        ),
      ),
    );
  }


}
