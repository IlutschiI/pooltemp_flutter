import 'dart:async';
import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/lineGraphCard.dart';
import 'package:pooltemp_flutter/components/loadingOverlay.dart';
import 'package:pooltemp_flutter/converter/temperatureSeriesConverter.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/temperatureService.dart';

class TemperatureDetails extends StatelessWidget {
  final String _sensorId;

  TemperatureDetails(this._sensorId);

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
                  return Center(child: CircularProgressIndicator(),);
                }
              }),
        ],
      ),
    );
  }

  Future<List<Series<Temperature, DateTime>>> loadData() async {
    List<Temperature> temps;
    temps = await TemperatureService().findAllTemperatureForSensor(_sensorId);
    return TemperatureSeriesConverter().convert(temps);
  }
}
