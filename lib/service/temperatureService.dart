import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureService {
  Future<Temperature> findActualTemperatureForSensor(String sensor) async {
    return findAllTemperatureForSensor(sensor).then((values) => values.last);
  }

  Future<List<Temperature>> findAllTemperatureForSensor(String sensor) async {
    final response =
        await http.get("http://mypooltemp.ddns.net:8000/temperature");
    if (response.statusCode == 200) {
      List list = json.decode(response.body);

      List<Temperature> temps = new List();
      for (var temperature in list) {
        temps.add(Temperature.fromJson(temperature));
      }
      temps = temps.where((temp) => temp.sensorID.trim() == sensor).toList();
      temps.removeWhere((t) => t.temperature == 0.0 || t.temperature == 85.0);
      temps.sort((t1, t2) => t1.time.compareTo(t2.time));

      var result = List<Temperature>();
      for (var i = 0; i < temps.length; i++) {
        if (i % 100 == 0) result.add(temps.elementAt(i));
      }

      return result;
    } else {
      throw Exception("couldnt fetch data...");
    }
  }
}
