import 'dart:async';
import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FutureBuilder(
              future: loadGraph(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return LineGraphCard(snapshot.data);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
              FutureBuilder(
                  future: loadHighestTemperature(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Temperature t = snapshot.data;
                      return CustomCard(
                          child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${t.temperature}",
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Highest Temperature",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
          CustomCard(
            child: Text("das ist ein text"),
          )
        ],
      ),
    );
  }

  Future<List<Series<Temperature, DateTime>>> loadGraph() async {
    List<Temperature> temps;
    temps = await TemperatureService().findAllTemperatureForSensor(_sensorId);
    return TemperatureSeriesConverter().convert(temps);
  }

  Future<Temperature> loadHighestTemperature() async {
    return await TemperatureService().findHighestTemperatureForSensor(_sensorId);
  }
}
