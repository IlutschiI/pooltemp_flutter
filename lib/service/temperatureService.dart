import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureService{

  Future<Temperature> findActualTemperatureForSensor(String sensor) async {
    final response = await http.get("http://mypooltemp.ddns.net:8000/temperature");
    if(response.statusCode==200){
      List list= json.decode(response.body);

      List<Temperature> temps = new List();
      for(var temperature in list){
        temps.add(Temperature.fromJson(temperature));
      }
      return temps.where((temp)=>temp.sensorID.trim()==sensor).last;
    }
    else{
      throw Exception("couldnt fetch data...");
    }
  }

}