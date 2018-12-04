import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class LineGraphCard extends StatefulWidget{

  List<charts.Series<Temperature, DateTime>> _series;


  LineGraphCard(this._series);

  @override
  _LineGraphCardState createState() {
    return new _LineGraphCardState();
  }
}

class _LineGraphCardState extends State<LineGraphCard> {

  Temperature _selectedTemperature;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomCard(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              //maybe replace this Chart with a selfmade widget, which uses this chart
              child: charts.TimeSeriesChart(
                widget._series,
                dateTimeFactory:charts.LocalDateTimeFactory(),
                animate: false,
                selectionModels: [
                  charts.SelectionModelConfig(type: charts.SelectionModelType.info, changedListener: _onSelectionChanged),

                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text(_selectedTemperature!=null?DateFormat(DateFormat.YEAR_MONTH_DAY).format(_selectedTemperature.time):""),
                Text((_selectedTemperature!=null?_selectedTemperature.temperature.toString()+"°C":"")),
              ],
            )
          ],
        ));
  }

  _onSelectionChanged(charts.SelectionModel<DateTime> model) {
    if(model.hasAnySelection) {
      setState(() {
        _selectedTemperature = model.selectedDatum.first.datum;
      });
    }else{
      setState(() {
        _selectedTemperature = null;
      });
    }
  }
}