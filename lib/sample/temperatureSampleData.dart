import 'dart:math';

import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureSampleData {

  List<Temperature> createSampleData(double _startingTemp) {
    List<Temperature> data = List();
    final random = Random();
    var prevTemp = _startingTemp;
    var actualTemp = 0.0;
    for (int i = 0; i < 100; i++) {
      actualTemp = _findRandomTemperature(random, prevTemp, _startingTemp);
      prevTemp = actualTemp;
      data.add(Temperature(time: DateTime.now().subtract(Duration(hours: i)), temperature: actualTemp));
    }

    return data;
  }

  //finding next "random" number
  //number can only have a differnce of +-0.5 to have nice and clean chart
  double _findRandomTemperature(Random random, double prevTemp, double _startingTemp) {
    var offset = 0.5;
    var temperature = random.nextDouble() * _startingTemp * 20;
    while (temperature >= prevTemp + offset || temperature <= prevTemp - offset) {
      temperature = random.nextDouble() * _startingTemp * 20;
    }
    return temperature;
  }

}