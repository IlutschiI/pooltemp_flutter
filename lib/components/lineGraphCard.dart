import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pooltemp_flutter/components/DateTimePicker.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/converter/temperatureSeriesConverter.dart';
import 'package:pooltemp_flutter/model/downsizeListWrapper.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:pooltemp_flutter/service/temperatureListService.dart';

class LineGraphCard extends StatefulWidget {
  List<Temperature> _temperatures = new List();

  LineGraphCard(this._temperatures);

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
    _startDate = widget._temperatures.first.time;
    _endDate = widget._temperatures.last.time;
    updateChart();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomCard(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 150,
                      child: DateTimePicker(
                        value: _startDate,
                        onValueChanged: (d) =>
                            setState(() {
                              _startDate = d;
                              updateChart();
                            }),
                      )),
                  Container(
                      width: 150,
                      child: DateTimePicker(
                        value: _endDate,
                        onValueChanged: (d) =>
                            setState(() {
                              _endDate = d;
                              updateChart();
                            }),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              height: 25,
              child: ListView(
                scrollDirection: Axis.horizontal,itemExtent: 65,
                children: <Widget>[
                  // @formatter:off
                  Container(margin: EdgeInsets.all(2.5), child: RaisedButton(color: Colors.white,child: Text("1D"),onPressed: (){_setGraphDate(Duration(days: 1));},),),
                  Container(margin: EdgeInsets.all(2.5), child: RaisedButton(color: Colors.white,child: Text("7D"),onPressed: (){_setGraphDate(Duration(days: 7));},),),
                  Container(margin: EdgeInsets.all(2.5), child: RaisedButton(color: Colors.white,child: Text("1M"),onPressed: (){_setGraphDate(Duration(days: 31));},),),
                  Container(margin: EdgeInsets.all(2.5), child: RaisedButton(color: Colors.white,child: Text("6M"),onPressed: (){_setGraphDate(Duration(days: 186));},),),
                  Container(margin: EdgeInsets.all(2.5), child: RaisedButton(color: Colors.white,child: Text("1Y"),onPressed: (){_setGraphDate(Duration(days: 365));},),),
                  Container(margin: EdgeInsets.all(2.5), child: RaisedButton(color: Colors.white,child: Text("ALL"),onPressed: (){_setGraphDateToMax();},),),
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
                  Text(_selectedTemperature != null ? DateFormat(DateFormat.YEAR_MONTH_DAY).format(_selectedTemperature.time) : ""),
                ],
              ),
            )
          ],
        ));
  }

  void updateChart() async {
    DownsizeListWrapper wrapper= DownsizeListWrapper(widget._temperatures, _startDate, _endDate);
    var list = await compute(TemperatureListService.downsizeList, wrapper);
    setState(() {
      _series = TemperatureSeriesConverter().convert(list);
    });
   /* downsizeList(widget._temperatures, _startDate, _endDate).then((list) {
      setState(() {
        _series = TemperatureSeriesConverter().convert(list);
      });
    });*/
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
      _startDate = widget._temperatures.last.time.subtract(beforeEndDate);
      _endDate = widget._temperatures.last.time;
    });
    updateChart();
  }

  _setGraphDateToMax() {
    setState(() {
      _startDate = widget._temperatures.first.time;
      _endDate = widget._temperatures.last.time;
    });
    updateChart();
  }
}
