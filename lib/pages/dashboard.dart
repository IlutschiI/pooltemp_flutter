import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/components/temperatureCard.dart';
import 'package:pooltemp_flutter/model/sensor.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
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

  bool _isloading = true;

  @override
  void initState() {
    loadSensors().then((sensors) {
      _sensors = sensors;
      loadTemperatureForSensors().then((list) {
        setState(() {
          _temperatures = list;
          _isloading = false;
        });
      });
    });
  }

  Future<List<Sensor>> loadSensors() async {
    return await SensorService().findSensorIds();
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
      _isloading = true;
    });

    loadSensors().then((sensors) {
      _sensors = sensors;
      loadTemperatureForSensors().then((list) {
        setState(() {
          _temperatures = list;
          _isloading = false;
        });
      });
    });

    //loadTemperatureForSensors();
  }

  void navigateToDetails(BuildContext context, Temperature temperature) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => TemperatureDetails(),));

    //this is a navigation with a simple slide transition the one above works just fine, but has no transition
    Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return TemperatureDetails(temperature.temperature, temperature.sensorID);
        }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: new SlideTransition(
              position: new Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(1.0, 0.0),
              ).animate(secondaryAnimation),
              child: child,
            ),
          );
        }));
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
                    child: TemperatureCard(t),
                    onTap: () => navigateToDetails(context, t),
                  ),
                  margin: EdgeInsets.only(top: 5),
                ))
            .toList(),
      ),
    ];

    if (_isloading) {
      childrens.add(Stack(
        children: <Widget>[
          Opacity(
              opacity: 0.5,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black,
              )),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ));
    }

    return childrens;
  }
}
