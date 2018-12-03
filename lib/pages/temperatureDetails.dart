import 'dart:async';
import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/lineGraphCard.dart';
import 'package:pooltemp_flutter/converter/temperatureSeriesConverter.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/sample/temperatureSampleData.dart';
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
      temps = await TemperatureService().findAllTemperatureForSensor(_sensorId);
    } catch (e) {
      temps = TemperatureSampleData().createSampleData(_startingTemp);
    }
    return TemperatureSeriesConverter().convert(temps);
  }

}
