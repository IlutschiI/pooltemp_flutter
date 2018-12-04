import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pooltemp_flutter/model/sensor.dart';
import 'package:pooltemp_flutter/service/baseUrl.dart';

class SensorService {
  Future<List<Sensor>> findSensorIds() async {
    http.Response response = await http.get(BaseUrl.baseURL+"/sensor");
    List<dynamic> responseList = json.decode(response.body);

    return responseList.map((res)=>Sensor.fromJson(res)).toList();
  }
}
