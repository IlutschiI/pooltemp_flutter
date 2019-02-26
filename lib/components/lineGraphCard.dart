import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pooltemp_flutter/components/DateTimePicker.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/components/dateButton.dart';
import 'package:pooltemp_flutter/converter/temperatureSeriesConverter.dart';
import 'package:pooltemp_flutter/model/downsizeListWrapper.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/service/temperatureListService.dart';

class LineGraphCard extends StatefulWidget {
  List<Temperature> temperatures = new List();

  LineGraphCard({this.temperatures});

  @override
  _LineGraphCardState createState() {
    return new _LineGraphCardState();
  }
}

class _LineGraphCardState extends State<LineGraphCard> {
  List<charts.Series<Temperature, DateTime>> _series = new List();
  final dateFormat = DateFormat("dd.MM.yyyy");
  Temperature _selectedTemperature;
  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    _startDate = widget.temperatures?.first?.time;
    _endDate = widget.temperatures?.last?.time;
    updateChart();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomCard(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: DateTimePicker(
                            timeEnabled: false,
                            value: _startDate,
                            onValueChanged: (d) {
                              setState(() {
                                _startDate = d;
                              });
                              updateChart();
                            },
                          )),
                      Expanded(
                          child: DateTimePicker(
                            timeEnabled: false,
                            value: _endDate,
                            onValueChanged: (d) =>
                                setState(() {
                                  _endDate = d;
                                  _endDate.add(Duration(hours: 23,minutes: 59,seconds: 59));
                                  updateChart();
                                }),
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal, itemExtent: 65,
                    children: <Widget>[
                      // @formatter:off
                      DateButton(color: Colors.white, text: "1D", onTap:(){ _setGraphDate(Duration(days: 1));},),
                      DateButton(color: Colors.white, text: "7D", onTap:(){ _setGraphDate(Duration(days: 7));},),
                      DateButton(color: Colors.white, text: "1M", onTap: (){_setGraphDate(Duration(days: 31));},),
                      DateButton(color: Colors.white, text: "6M", onTap: (){_setGraphDate(Duration(days: 186));},),
                      DateButton(color: Colors.white, text: "1Y", onTap: (){_setGraphDate(Duration(days: 365));},),
                      DateButton(color: Colors.white, text: "ALL", onTap: (){_setGraphDateToMax();}),
                      // @formatter:on
                    ],
                  ),
                ),
                Container(
                  height: 300,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.all(10),
                  //maybe replace this Chart with a selfmade widget, which uses this chart
                  child: _series.length != 0
                      ? charts.TimeSeriesChart(
                    _series,
                    dateTimeFactory: charts.LocalDateTimeFactory(),
                    animate: true,
                    selectionModels: [
                      charts.SelectionModelConfig(type: charts.SelectionModelType.info, changedListener: _onSelectionChanged),
                    ],
                  )
                      : Container(),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Column(
                    children: <Widget>[
                      Text((_selectedTemperature != null ? _selectedTemperature.temperature.toString() + "°C" : "")),
                      Text(_selectedTemperature != null ? DateFormat("d MMMM y HH:mm").format(_selectedTemperature.time) : ""),
                    ],
                  ),
                )
              ],
            ),
            widget.temperatures == null ?
            CircularProgressIndicator() : Container()
          ],
        ));
  }


  void updateChart() async {
    DownsizeListWrapper wrapper = DownsizeListWrapper(widget.temperatures, _startDate, _endDate);
    var list = await compute(TemperatureListService.downsizeList, wrapper);
    setState(() {
      _series = TemperatureSeriesConverter().convert(list);
    });
  }

  _onSelectionChanged(charts.SelectionModel<DateTime> model) {
    if (model.hasAnySelection) {
      setState(() {
        _selectedTemperature = model.selectedDatum.first.datum;
      });
    } else {
      setState(() {
        _selectedTemperature = null;
      });
    }
  }

  _setGraphDate(Duration beforeEndDate) {
    setState(() {
      _startDate = widget.temperatures.last.time.subtract(beforeEndDate);
      _endDate = widget.temperatures.last.time;
    });
    updateChart();
  }

  _setGraphDateToMax() {
    setState(() {
      _startDate = widget.temperatures.first.time;
      _endDate = widget.temperatures.last.time;
    });
    updateChart();
  }
}
