import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/components/loadingOverlay.dart';
import 'package:pooltemp_flutter/components/temperatureCard.dart';
import 'package:pooltemp_flutter/model/sensor.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/navigator/navigator.dart';
import 'package:pooltemp_flutter/pages/temperatureDetails.dart';
import 'package:pooltemp_flutter/service/sensorService.dart';
import 'package:pooltemp_flutter/service/temperatureService.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Sensor> _sensors = new List();
  List<Temperature> _temperatures = new List();
  TemperatureService _service = TemperatureService();

  bool _isLoading = true;

  @override
  void initState() {
    loadData();
  }

  void loadData() {
    SensorService().findSensorIds().then((sensors) {
      _sensors = sensors;
      loadTemperatureForSensors().then((list) {
        setState(() {
          _temperatures = list;
          _isLoading = false;
        });
      });
    });
  }

  Future<List<Temperature>> loadTemperatureForSensors() async {
    List<Temperature> list = List();

    for (Sensor sensor in _sensors) {
      list.add(await _service.findActualTemperatureForSensor(sensor.id));
    }
    return list;
  }

  void relaod() {
    setState(() {
      _isLoading = true;
    });

    loadData();
  }

  void navigateToDetails(BuildContext context, Temperature temperature) {
    CustomNavigator().navigateTo(context, TemperatureDetails(temperature.sensorID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: relaod,
        child: Icon(Icons.refresh),
        elevation: 2.0,
      ),
      body: new Material(
          color: Colors.blueAccent,
          child: Stack(
            children: buildChildren(context),
          )),
    );
  }

  List<Widget> buildChildren(BuildContext context) {
    var childrens = <Widget>[
      new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _temperatures
            .map((t) => Container(
                  child: InkWell(
                    child: TemperatureCard(t,_sensors.firstWhere((s)=>s.id==t.sensorID)),
                    onTap: () => navigateToDetails(context, t),
                  ),
                  margin: EdgeInsets.only(top: 5),
                ))
            .toList(),
      ),
    ];

    if (_isLoading) {
      childrens.add(LoadingOverlay());
    }

    return childrens;
  }
}
