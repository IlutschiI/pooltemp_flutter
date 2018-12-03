import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/components/temperatureCard.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/pages/temperatureDetails.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  List<Temperature> _temperatures=new List();

  @override
  void initState() {
    _temperatures.add(new Temperature(sensorID: "28-80000026d871", temperature: 12.0));
    _temperatures.add(new Temperature(sensorID: "4A3-097-F3BC", temperature: 23.0));
  }

  void relaod(){
    setState(() {
      _temperatures[0].temperature++;
      _temperatures[1].temperature++;
    });
  }

  void navigateToDetails(BuildContext context, Temperature temperature){
   // Navigator.push(context, MaterialPageRoute(builder: (context) => TemperatureDetails(),));


    //this is a navigation with a simple slide transition the one above works just fine, but has no transition
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context,Animation<double> animation,Animation<double>secondaryAnimation){
      return TemperatureDetails(temperature.temperature, temperature.sensorID);
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
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
          children: _temperatures.map((t)=>Container(
            child:InkWell(child: TemperatureCard(t),onTap:() => navigateToDetails(context, t),),
            margin: EdgeInsets.only(top: 5),
          )).toList(),
        ),
      ),
    );
  }


}
