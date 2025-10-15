import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/baseUrl.dart';

class TemperatureService {
  Future<Temperature> findActualTemperatureForSensor(String sensor) async {
    final response = await http.get(Uri.parse(BaseUrl.baseURL + "/temperature/latest?sensor=" + sensor));
    return Temperature.fromJson(json.decode(response.body));
  }

  Future<Temperature> findHighestTemperatureForSensor(String sensor) async {
    return _findHighestTemperatureForSensor(sensor);
  }

  Future<Temperature> findLowestTemperatureForSensor(String sensor) async {
    return _findLowestTemperatureForSensor(sensor);
  }

  Future<List<Temperature>> findAllTemperatureForSensor(String sensor) async {
    final response = await http.get(Uri.parse(BaseUrl.baseURL + "/temperature?sensor=" + sensor));
    if (response.statusCode == 200) {
      List list = json.decode(response.body);

      List<Temperature> temps = [];
      for (var temperature in list) {
        temps.add(Temperature.fromJson(temperature));
      }
      temps.sort((t1, t2) => t1.time.compareTo(t2.time));

      var result = <Temperature>[];
      result.addAll(temps);

      return result;
    } else {
      throw Exception("couldnt fetch data...");
    }
  }

  Future<Temperature> _findHighestTemperatureForSensor(String sensor) async {
    final response = await http.get(Uri.parse(BaseUrl.baseURL + "/temperature/highest?sensor=" + sensor));

    if (response.statusCode == 200) {
      return Temperature.fromJson(json.decode(response.body));
    } else {
      throw Exception("couldnt fetch highest temperature for " + sensor);
    }
  }

  Future<Temperature> _findLowestTemperatureForSensor(String sensor) async {
    final response = await http.get(Uri.parse(BaseUrl.baseURL + "/temperature/lowest?sensor=" + sensor));

    if (response.statusCode == 200) {
      return Temperature.fromJson(json.decode(response.body));
    } else {
      throw Exception("couldnt fetch lowest temperature for " + sensor);
    }
  }
}
