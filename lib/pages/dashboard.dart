import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/components/temperatureCard.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/pages/temperatureDetails.dart';
import 'package:pooltemp_flutter/service/temperatureService.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Temperature> _temperatures = new List();
  TemperatureService _service = TemperatureService();

  @override
  void initState() {
    loadTemperatureForSensors();
  }

  void loadTemperatureForSensors() {
    _temperatures.clear();
    _service.findActualTemperatureForSensor("28-80000026d871\n").then((temperature) {
      setState(() {
        _temperatures.add(temperature);
      });
    });

    _service.findActualTemperatureForSensor("28-0316a34e6dff\n").then((temperature) {
      setState(() {
        _temperatures.add(temperature);
      });
    });
  }

  void relaod() {
    loadTemperatureForSensors();
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
        child: new Column(
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
      ),
    );
  }
}
