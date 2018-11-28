import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:pooltemp_flutter/components/card.dart';

import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomCard(
              child: Container(
            height: 300,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            //maybe replace this Chart with a selfmade widget, which uses this chart
            child: TimeSeriesChart(
              createSampleData(),
              dateTimeFactory: LocalDateTimeFactory(),
              animate: false,
            ),
          )),
        ],
      ),
    );
  }

  //This is just for demo purpose; replace this with loading actual Data
  List<Series<Temperature, DateTime>> createSampleData() {
    List<Temperature> data = List();
    final random = Random();
    var prevTemp = 10.0;
    var actualTemp = 0.0;
    for (int i = 0; i < 100; i++) {
      actualTemp = findRandomTemperature(random, prevTemp);
      prevTemp = actualTemp;
      data.add(Temperature(time: DateTime.now().subtract(Duration(hours: i)), temperature: actualTemp));
    }

    return [
      new Series<Temperature, DateTime>(id: "temperatures", data: data, domainFn: (Temperature temperature, _) => temperature.time, measureFn: (Temperature temperature, _) => temperature.temperature)
    ];
  }

  //finding next "random" number
  //number can only have a differnce of +-0.5 to have nice and clean chart
  double findRandomTemperature(Random random, double prevTemp) {
    var offset = 0.5;
    var temperature = random.nextDouble() * 50;
    while (temperature >= prevTemp + offset || temperature <= prevTemp - offset) {
      temperature = random.nextDouble() * 15;
    }
    return temperature;
  }
}
