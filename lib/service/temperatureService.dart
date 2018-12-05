import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/baseUrl.dart';

class TemperatureService {
  Future<Temperature> findActualTemperatureForSensor(String sensor) async {
    final response = await http.get(BaseUrl.baseURL + "/temperature/latest?sensor=" + sensor);
    return Temperature.fromJson(json.decode(response.body));
  }

  Future<Temperature> findHighestTemperatureForSensor(String sensor) async {
    var list = await findAllTemperatureForSensor(sensor);
    list.sort((temp1, temp2) => temp1.temperature.compareTo(temp2.temperature));
    return list.last;
  }

  Future<Temperature> findLowestTemperatureForSensor(String sensor) async {
    var list = await findAllTemperatureForSensor(sensor);
    list.sort((temp1, temp2) => temp1.temperature.compareTo(temp2.temperature));
    return list.first;
  }

  Future<List<Temperature>> findAllTemperatureForSensor(String sensor) async {
    final response = await http.get(BaseUrl.baseURL + "/temperature?sensor=" + sensor);
    if (response.statusCode == 200) {
      List list = json.decode(response.body);

      List<Temperature> temps = new List();
      for (var temperature in list) {
        temps.add(Temperature.fromJson(temperature));
      }
      temps.sort((t1, t2) => t1.time.compareTo(t2.time));

      var result = List<Temperature>();
      result.addAll(temps);

      return result;
    } else {
      throw Exception("couldnt fetch data...");
    }
  }
}
