import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pooltemp_flutter/components/LineChart.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/converter/temperatureSeriesConverter.dart';
import 'package:pooltemp_flutter/model/downsizeListWrapper.dart';
import 'package:pooltemp_flutter/model/sensor.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/temperatureListService.dart';
import 'package:pooltemp_flutter/service/temperatureService.dart';

class TemperatureCard extends StatefulWidget {
  final Temperature _temperature;
  TemperatureService _service = TemperatureService();
  final Sensor _sensor;

  TemperatureCard(this._temperature, this._sensor);

  @override
  _TemperatureCardState createState() => _TemperatureCardState();
}

class _TemperatureCardState extends State<TemperatureCard> {
  @override
  Widget build(BuildContext context) {
    return new CustomCard(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "${widget._temperature.temperature.toStringAsFixed(2)} °C",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: Icon(
                        FontAwesomeIcons.thermometerHalf,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: loadGraphData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Expanded(
                      child: Container(
                        height: 70,
                        child: snapshot.hasData
                            ? LineChart(
                                series: snapshot.data,
                                isZoomable: false,
                                showXAxis: false,
                              )
                            : Center(child: CircularProgressIndicator()),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  widget._sensor.name != null ? widget._sensor.name.trim() : widget._sensor.id.trim(),
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  child: Icon(
                    Icons.wifi_tethering,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List> loadGraphData() async {
    var temperatures = await widget._service.findAllTemperatureForSensor(widget._sensor.id);
    var _startDate = temperatures.last.time.subtract(Duration(days: 3));
    var _endDate = temperatures.last.time;
    DownsizeListWrapper wrapper = DownsizeListWrapper(temperatures, _startDate, _endDate);
    var list = await compute(TemperatureListService.downsizeList, wrapper);
    return TemperatureSeriesConverter().convert(list);
  }
}
