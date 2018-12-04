import 'dart:async';
import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/components/lineGraphCard.dart';
import 'package:pooltemp_flutter/components/loadingOverlay.dart';
import 'package:pooltemp_flutter/converter/temperatureSeriesConverter.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/temperatureService.dart';

class TemperatureDetails extends StatelessWidget {
  final String _sensorId;

  TemperatureDetails(this._sensorId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
              future: loadGraph(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return LineGraphCard(snapshot.data);
                } else {
                  return Center(
                    child:CustomCard(
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          //maybe replace this Chart with a selfmade widget, which uses this chart
                          child: Center(child: CircularProgressIndicator()),
                        )),
                  );
                }
              }),
          buildDetailRow(),
          CustomCard(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text("das ist ein text"),
          )
        ],
      ),
    );
  }

  Row buildDetailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: CustomCard(
            margin: EdgeInsets.only(left: 20, right: 4, top: 10),
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: FutureBuilder(
                  future: loadHighestTemperature(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Temperature t = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${t.temperature}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Highest Temperature",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(margin: EdgeInsets.only(top: 4, bottom: 4), child: CircularProgressIndicator()),
                      );
                    }
                  }),
            ),
          ),
        ),
        Expanded(
          child: CustomCard(
            margin: EdgeInsets.only(left: 4, right: 20, top: 10),
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: FutureBuilder(
                  future: loadLowestTemperature(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Temperature t = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${t.temperature}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Lowest Temperature",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(margin: EdgeInsets.only(top: 4, bottom: 4), child: CircularProgressIndicator()),
                      );
                    }
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Series<Temperature, DateTime>>> loadGraph() async {
    List<Temperature> temps;
    temps = await TemperatureService().findAllTemperatureForSensor(_sensorId);
    return TemperatureSeriesConverter().convert(temps);
  }

  Future<Temperature> loadHighestTemperature() async {
    return await TemperatureService().findHighestTemperatureForSensor(_sensorId);
  }

  Future<Temperature> loadLowestTemperature() async {
    return await TemperatureService().findLowestTemperatureForSensor(_sensorId);
  }
}
