import 'dart:async';
import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/lineGraphCard.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/temperatureService.dart';

class TemperatureDetails extends StatelessWidget {
  final double _startingTemp;
  final String _sensorId;

  TemperatureDetails(this._startingTemp, this._sensorId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
              future: loadData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return LineGraphCard(snapshot.data);
                } else {
                  return Text("loading data...");
                }
              }),
        ],
      ),
    );
  }

  Future<List<Series<Temperature, DateTime>>> loadData() async {
    List<Temperature> temps;
    try {
      temps = await TemperatureService()
          .findAllTemperatureForSensor(_sensorId);
    }catch(e){
      temps=createSampleData();
    }
    return convertIntoSeries(temps);
  }

  //This is just for demo purpose; replace this with loading actual Data
  List<Temperature> createSampleData() {
    List<Temperature> data = List();
    final random = Random();
    var prevTemp = _startingTemp;
    var actualTemp = 0.0;
    for (int i = 0; i < 100; i++) {
      actualTemp = findRandomTemperature(random, prevTemp);
      prevTemp = actualTemp;
      data.add(Temperature(
          time: DateTime.now().subtract(Duration(hours: i)),
          temperature: actualTemp));
    }

    return data;
  }

  //finding next "random" number
  //number can only have a differnce of +-0.5 to have nice and clean chart
  double findRandomTemperature(Random random, double prevTemp) {
    var offset = 0.5;
    var temperature = random.nextDouble() * _startingTemp * 20;
    while (
        temperature >= prevTemp + offset || temperature <= prevTemp - offset) {
      temperature = random.nextDouble() * _startingTemp * 20;
    }
    return temperature;
  }

  Future<List<Series<Temperature, DateTime>>> convertIntoSeries(
      List<Temperature> value) async{
    return [
      new Series(
          id: "temp",
          data: value,
          domainFn: (Temperature temp, _) => temp.time,
          measureFn: (Temperature temperature, _) => temperature.temperature)
    ];
  }
}
