import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/dateTimePicker.dart';
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
  DateTime tempTime = DateTime.now(); //TO be removed

  bool _isLoading = true;
  bool _hasError = false;

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
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
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
      _hasError = false;
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
    var childrens = <Widget>[];

    if (!_isLoading && !_hasError) {
      var list = _temperatures
          .map((t) => Container(
                child: InkWell(
                  child: TemperatureCard(t, _sensors.firstWhere((s) => s.id == t.sensorID)),
                  onTap: () => navigateToDetails(context, t),
                ),
                margin: EdgeInsets.only(top: 5),
              ))
          .toList();
      list.add(Container(
        child: DateTimePicker(
          value: tempTime,
          onValueChanged: (d) {
            print('callback: ${d.toString()}');
          },
        ),
      ));
      childrens.add(
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        ),
      );
    }

    if (_isLoading) {
      childrens.add(LoadingOverlay());
    }

    if (_hasError) {
      childrens.add(Center(
        child: Text("a fucking Error occured, please reload..."),
      ));
    }

    print('${tempTime.toString()}');
    return childrens;
  }
}
