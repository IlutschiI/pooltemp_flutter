import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/baseUrl.dart';

class TemperatureService {
  Future<Temperature> findActualTemperatureForSensor(String sensor) async {

    final response =
    await http.get(BaseUrl.baseURL+"/temperature/latest?sensor="+sensor);
    return Temperature.fromJson(json.decode(response.body));
  }

  Future<List<Temperature>> findAllTemperatureForSensor(String sensor) async {
    final response =
        await http.get(BaseUrl.baseURL+"/temperature");
    if (response.statusCode == 200) {
      List list = json.decode(response.body);

      List<Temperature> temps = new List();
      for (var temperature in list) {
        temps.add(Temperature.fromJson(temperature));
      }
      temps = temps.where((temp) => temp.sensorID == sensor).toList();
      temps.removeWhere((t) => t.temperature == 0.0 || t.temperature == 85.0);
      temps.sort((t1, t2) => t1.time.compareTo(t2.time));

      var result = List<Temperature>();
      if(temps.length>1000) {
        for (var i = 0; i < temps.length; i++) {
          if (i % 100 == 0) result.add(temps.elementAt(i));
        }
      } else{
        result.addAll(temps);
      }

      return result;
    } else {
      throw Exception("couldnt fetch data...");
    }
  }
}
